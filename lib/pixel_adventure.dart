// On branch dev

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
  List<String> levelNames = ['Level-04', 'Level-03', 'Level-02', 'Level-01'];
  int currentLevelIndex = -1; // was 0
  LevelManager levelManager = LevelManager();

  @override
  FutureOr<void> onLoad() async {
    //debugMode = true;
    // load all images into cache
    await images.loadAllImages();

    // _loadLevel();

    await add(gameManager);

    await add(levelManager);

    //overlays.add('gameOverlay');

    //  startGame();

    if (showControls) {
      //addJoyStick();
      //addJumpButton();
    }
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

    if (gameManager.isPlaying) {
      overlays.add('gameOverlay');
    }

    if (gameManager.isGameOver) {
      return;
    }

    if (gameManager.isIntro) {
      overlays.add('mainMenuOverlay');
      return;
    }

    if (gameManager.isPlaying) {
      if (showControls) {
        //updateJoyStick();
      }

      if (gameManager.livesRemaining.value == 0) {
        onLose();
      }
    }

    // if (showControls) {
    //   updateJoyStick();
    // }
  }

  void initializeGameStart() {
    setCharacter();
    gameManager.reset();
    levelManager.reset();
  }

  void startGame() {
    //_loadLevel();
    loadNextLevel();
    initializeGameStart();
    gameManager.state = GameState.playing;
    overlays.remove('mainMenuOverlay');
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
    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      // no more levels, game finishes
      currentLevelIndex = 0;
      _loadLevel();
    }
  }

  void _loadLevel() {
    removeWhere((component) => component is Level);

    Future.delayed(
      const Duration(seconds: 1),
      () {
        Level world = Level(
          player: player,
          //player: Player(character: Character.maskDude),
          levelName: levelNames[currentLevelIndex],
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

    // void addJoyStick() {
  //   joystick = JoystickComponent(
  //       priority: 10,
  //       knob: SpriteComponent(
  //         sprite: Sprite(
  //           images.fromCache('HUD/Knob.png'),
  //         ),
  //       ),
  //       background: SpriteComponent(
  //         sprite: Sprite(
  //           images.fromCache('HUD/Joystick.png'),
  //         ),
  //       ),
  //       margin: const EdgeInsets.only(left: 40, bottom: 40));

  //   add(joystick);
  // }

  // void updateJoyStick() {
  //   switch (joystick.direction) {
  //     case JoystickDirection.left:
  //     case JoystickDirection.upLeft:
  //     case JoystickDirection.downLeft:
  //       player.horizontalMovement = -1;
  //       break;
  //     case JoystickDirection.right:
  //     case JoystickDirection.upRight:
  //     case JoystickDirection.downRight:
  //       player.horizontalMovement = 1;
  //       break;
  //     default:
  //       // idle
  //       player.horizontalMovement = 0;
  //       break;
  //   }
  // }

    // void addJumpButton() {
  //   final jumpButton = HudButtonComponent(
  //       priority: 1000,
  //       button: SpriteComponent(
  //         sprite: Sprite(images.fromCache('HUD/JumpButton.png')),
  //       ),
  //       buttonDown: SpriteComponent(
  //           sprite: Sprite(images.fromCache('HUD/JumpButton.png'))),
  //       margin: const EdgeInsets.only(
  //         right: 40,
  //         bottom: 40,
  //       ),
  //       onPressed: pressJump);

  //   add(jumpButton);
  // }
}
