import 'dart:async';
// import 'dart:ui';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/level.dart';
import 'package:pixel_adventure/managers/game_manager.dart';
import 'package:pixel_adventure/managers/level_manager.dart';

enum Character { ninjaFrog, maskDude, pinkMan, virtualGuy }

class PixelAdventure extends FlameGame
    with
        HasKeyboardHandlerComponents,
        DragCallbacks,
        HasCollisionDetection,
        TapCallbacks {
  //PixelAdventure({super.children, required this.player});

  //Player player = Player(character: Character.maskDude);

  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late CameraComponent cam;
  //Player player = Player(character: 'Pink Man');
  late Player player;
  Character character = Character.pinkMan;
  GameManager gameManager = GameManager();
  late JoystickComponent joystick;
  bool showControls = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  // bool showControls = true;
  bool playSounds = true;
  double soundVolume = 1.0;
  //List<String> levelNames = ['Level-04', 'Level-03', 'Level-02', 'Level-01'];
  int currentLevelIndex = 0; // was 0
  LevelManager levelManager = LevelManager();

  @override
  FutureOr<void> onLoad() async {
    //debugMode = true;
    // load all images into cache
    await images.loadAllImages();

    await add(gameManager);

    await add(levelManager);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    //overlays.add('mainMenuOverlay');
    //overlays.remove('mainMenuOverlay');

    //  Future.delayed(const Duration(seconds: 6), () {
    //   // switch level
    //   overlays.add('gameOverlay');
    // });

    if (gameManager.isPickLevel) {
      overlays.add('levelOverlay');
      return;
    }

    if (gameManager.isIntro) {
      overlays.add('mainMenuOverlay');
      return;
    }

    if (gameManager.isGameOver) {
      return;
    }

    if (gameManager.isPlaying) {
      overlays.add('gameOverlay');
    }

    if (gameManager.isPlaying) {
      if (showControls) {
        //updateJoyStick();
      }

      if (gameManager.livesRemaining.value == 0) {
        onLose();
      }
    }
  }

  void initializeGameStart() {
    setCharacter();
    gameManager.reset();
    levelManager.reset();
  }

  void setLevel() {
    gameManager.state = GameState.pickLevel;
    overlays.remove('mainMenuOverlay');
    //overlays.add('levelOverlay');
  }

  void startGame() {
    //overlays.remove('levelOverlay');
    //_loadLevel();
    loadNextLevel();
    initializeGameStart();
    gameManager.state = GameState.playing;
    //overlays.remove('mainMenuOverlay');
    overlays.remove('levelOverlay');
  }

  void resetGame() {
    startGame();
    overlays.remove('gameOverOverlay');
    // gameManager.state = GameState.playing;
    // _loadLevel();
  }

  void quitGame() {
    overlays.remove('gameOverOverlay');
    gameManager.reset();
  }

  void onLose() {
    gameManager.state = GameState.gameOver;
    //player.removeFromParent();
    world.removeFromParent();
    overlays.add('gameOverOverlay');
  }

  void setCharacter() {
    player = Player(
      character: gameManager.character,
    );
    //add(player);
  }

  void pressJump() {
    player.hasJumped = true;
  }

  void loadNextLevel() {
    // if (currentLevelIndex < levelNames.length - 1) {
    //   currentLevelIndex++;
    //   _loadLevel();
    // } else {
    //   // no more levels, game finishes
    //   currentLevelIndex = 0;
    //   _loadLevel();
    // }

    levelManager.increaseLevel();
    _loadLevel();
  }

  void _loadLevel() {
    removeWhere((component) => component is Level);

    Future.delayed(
      const Duration(seconds: 1),
      () {
        Level world = Level(
          player: player,
          levelName: levelManager.levels[levelManager.level] ?? "Level-02",
        );

        cam = CameraComponent.withFixedResolution(
            width: 640, height: 360, world: world);
        cam.viewfinder.anchor = Anchor.topLeft;

        addAll([cam..priority = 0, world]);
      },
    );
  }

  void togglePauseState() {
    if (paused) {
      resumeEngine();
    } else {
      pauseEngine();
    }
  }
}
