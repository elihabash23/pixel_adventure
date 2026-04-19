import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';
import 'package:pixel_adventure/constants/game_constants.dart';
import 'package:pixel_adventure/managers/analytics_manager.dart';
import 'package:pixel_adventure/managers/game_manager.dart';
import 'package:pixel_adventure/managers/level_manager.dart';
import 'package:pixel_adventure/managers/save_manager.dart';

enum Character { ninjaFrog, maskDude, pinkMan, virtualGuy }

class PixelAdventure extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  @override
  Color backgroundColor() =>
      const Color.fromARGB(255, 255, 194, 0); //Color(0xFF211F30);
  CameraComponent? cam;
  Level? _currentLevel;
  late Player player;
  Character character = Character.pinkMan;
  GameManager gameManager = GameManager();
  late JoystickComponent joystick;
  bool showControls = kIsWeb ? false : (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);
  bool playSounds = true;
  double soundVolume = 1.0;
  LevelManager levelManager = LevelManager();
  SaveManager saveManager = SaveManager();
  AnalyticsManager analytics = AnalyticsManager();

  @override
  FutureOr<void> onLoad() async {
    try {
      // Initialize save manager first
      await saveManager.initialize();

      // Load saved settings
      if (saveManager.isInitialized) {
        playSounds = saveManager.getSoundEnabled();
        soundVolume = saveManager.getSoundVolume();

        if (kDebugMode) {
          print('Loaded saved settings - Sound: $playSounds, Volume: $soundVolume');
          saveManager.debugPrintAll();
        }
      }

      // Load all images into cache (Flame automatically caches loaded images)
      await images.loadAllImages();

      // Preload all level TMX files to improve performance
      await _preloadLevels();

      await add(gameManager);

      await add(levelManager);

      // Show initial overlay
      _updateOverlays();
    } catch (e) {
      // Log error but don't crash the game
      if (kDebugMode) {
        print('Error loading game assets: $e');
      }
      // Log error to analytics
      analytics.logError('Failed to load game assets: $e');
      // Still show the main menu even if some assets failed to load
      _updateOverlays();
    }

    return super.onLoad();
  }

  GameState _lastGameState = GameState.intro;

  @override
  void update(double dt) {
    super.update(dt);

    // Only update overlays when game state changes
    if (_lastGameState != gameManager.state) {
      _updateOverlays();
      _lastGameState = gameManager.state;
    }

    if (gameManager.isPlaying) {
      if (gameManager.livesRemaining.value == 0) {
        onLose();
      }
    }
  }

  void _updateOverlays() {
    // Remove all overlays first
    overlays.remove('mainMenuOverlay');
    overlays.remove('levelOverlay');
    overlays.remove('gameOverlay');
    overlays.remove('pauseOverlay');
    overlays.remove('gameOverOverlay');
    overlays.remove('theEndOverlay');

    // Add the appropriate overlay based on state
    if (gameManager.isIntro) {
      overlays.add('mainMenuOverlay');
    } else if (gameManager.isPickLevel) {
      overlays.add('levelOverlay');
    } else if (gameManager.isPlaying) {
      overlays.add('gameOverlay');
    } else if (gameManager.isPaused) {
      overlays.add('pauseOverlay');
    } else if (gameManager.isGameOver) {
      overlays.add('gameOverOverlay');
    } else if (gameManager.isTheEnd) {
      overlays.add('theEndOverlay');
    }
  }

  void initializeGameStart() {
    setCharacter();
    gameManager.reset();
    levelManager.reset();
  }

  void setLevel() {
    gameManager.state = GameState.pickLevel;
  }

  void startGame() {
    initializeGameStart();
    gameManager.state = GameState.playing;
    _loadLevel();

    // Track game start
    if (saveManager.isInitialized) {
      saveManager.incrementGamesPlayed();
    }
    analytics.logGameStart();
    analytics.logLevelStart(levelManager.level);
  }

  void resetGame() {
    startGame();
  }

  void quitGame() {
    gameManager.reset();
  }

  void onLose() {
    gameManager.state = GameState.gameOver;

    // Properly clean up level and camera to prevent resource leaks
    _currentLevel?.removeFromParent();
    _currentLevel = null;
    cam?.removeFromParent();
    cam = null;

    // Save high score if achieved
    if (saveManager.isInitialized) {
      saveManager.saveHighScore(gameManager.score.value);
    }

    // Log level failed
    analytics.logLevelFailed(levelManager.level, gameManager.score.value);
  }

  void onWin() {
    gameManager.state = GameState.theEnd;

    // Properly clean up level and camera to prevent resource leaks
    _currentLevel?.removeFromParent();
    _currentLevel = null;
    cam?.removeFromParent();
    cam = null;

    // Save high score and level completion
    if (saveManager.isInitialized) {
      saveManager.saveHighScore(gameManager.score.value);
      // Save that all levels were completed
      final highestLevel = levelManager.levels.keys.reduce((a, b) => a > b ? a : b);
      saveManager.saveLevelCompleted(highestLevel);

      if (kDebugMode) {
        print('Game completed! All levels finished.');
      }
    }

    // Log game complete
    analytics.logGameComplete(gameManager.score.value);
  }

  void setCharacter() {
    player = Player(
      character: gameManager.character,
    );
  }

  void pressJump() {
    player.hasJumped = true;
  }

  void loadNextLevel() {
    // Save level completion before moving to next level
    if (saveManager.isInitialized && levelManager.level > 0) {
      saveManager.saveLevelCompleted(levelManager.level);
    }

    // Log level complete
    if (levelManager.level > 0) {
      analytics.logLevelComplete(
        levelManager.level,
        gameManager.score.value,
        gameManager.livesRemaining.value,
      );
    }

    // Check if there's a next level
    if (levelManager.getNextValidLevel() != null) {
      levelManager.increaseLevel();
      _loadLevel();

      // Log new level start
      analytics.logLevelStart(levelManager.level);
    } else {
      // No more levels - game complete!
      onWin();
    }
  }

  void restartLevel() {
    gameManager.resetLives();
    _loadLevel();

    // Log level restart
    analytics.logLevelRestart(levelManager.level);
  }

  Future<void> _loadLevel() async {
    // Clean up previous level and camera to prevent resource leaks
    if (_currentLevel != null) {
      _currentLevel?.removeFromParent();
      _currentLevel = null;
    }
    if (cam != null) {
      cam?.removeFromParent();
      cam = null;
    }

    // Validate that the level exists in config
    if (!levelManager.levels.containsKey(levelManager.level)) {
      if (kDebugMode) {
        print('Level ${levelManager.level} not found in level config');
      }
      onWin();
      return;
    }

    // Check if level was validated during preload
    if (!levelManager.isLevelValid(levelManager.level)) {
      if (kDebugMode) {
        print('Level ${levelManager.level} (${levelManager.levels[levelManager.level]}) failed validation during preload');
      }
      // Try to load anyway, but we know it might fail
    }

    await Future.delayed(const Duration(seconds: GameLifecycleConstants.levelTransitionDelaySec));

    try {
      String levelName = levelManager.levels[levelManager.level]!;
      if (kDebugMode) {
        print('Loading level ${levelManager.level}: $levelName.tmx');
      }

      _currentLevel = Level(
        player: player,
        levelName: levelName,
      );

      cam = CameraComponent.withFixedResolution(
          width: CameraConstants.width, height: CameraConstants.height, world: _currentLevel!);
      cam!.viewfinder.anchor = Anchor.topLeft;

      await addAll([cam!..priority = 0, _currentLevel!]);

      if (kDebugMode) {
        print('Successfully loaded level ${levelManager.level}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading level ${levelManager.level} (${levelManager.levels[levelManager.level]}): $e');
      }
      // Log error to analytics
      analytics.logError(
        'Failed to load level ${levelManager.level}',
        context: {
          'level_number': levelManager.level,
          'level_name': levelManager.levels[levelManager.level] ?? 'unknown',
        },
      );
      // If level loading fails, try to recover by going to game over
      gameManager.state = GameState.gameOver;
      overlays.add('gameOverOverlay');
    }
  }

  void togglePauseState() {
    if (paused) {
      resumeEngine();
      gameManager.state = GameState.playing;
      analytics.logGameResumed(levelManager.level);
    } else {
      pauseEngine();
      gameManager.state = GameState.paused;
      analytics.logGamePaused(levelManager.level);
    }
  }

  Future<void> _preloadLevels() async {
    // Preload and validate all TMX level files
    if (kDebugMode) {
      print('Preloading ${levelManager.levels.length} levels...');
    }

    for (final entry in levelManager.levels.entries) {
      int levelNumber = entry.key;
      String levelName = entry.value;

      try {
        await TiledComponent.load('$levelName.tmx', Vector2.all(16));
        levelManager.markLevelAsValidated(levelNumber);

        if (kDebugMode) {
          print('✓ Level $levelNumber ($levelName.tmx) validated successfully');
        }
      } catch (e) {
        if (kDebugMode) {
          print('✗ Level $levelNumber ($levelName.tmx) failed to load: $e');
        }
        // Log error to analytics
        analytics.logError(
          'Failed to preload level',
          context: {
            'level_number': levelNumber,
            'level_name': levelName,
          },
        );
        // Don't mark as validated - this level will trigger warnings when loaded
      }
    }

    if (kDebugMode) {
      print('Preload complete. ${levelManager.levels.length} levels configured, ${levelManager.validatedLevelCount} validated');
    }
  }
}
