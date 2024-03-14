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

  @override
  Color backgroundColor() => const Color(0xFF211F30);
  late CameraComponent cam;
  late Player player;
  Character character = Character.pinkMan;
  GameManager gameManager = GameManager();
  late JoystickComponent joystick;
  bool showControls = !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  bool playSounds = true;
  double soundVolume = 1.0;
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
      // if (showControls) {
      //   //updateJoyStick();
      // }

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
  }

  void startGame() {
    loadNextLevel();
    initializeGameStart();
    gameManager.state = GameState.playing;
    overlays.remove('levelOverlay');
  }

  void resetGame() {
    startGame();
    overlays.remove('gameOverOverlay');
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
  }

  void pressJump() {
    player.hasJumped = true;
  }

  void loadNextLevel() {
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
