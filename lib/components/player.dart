import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/components/checkpoint.dart';
import 'package:pixel_adventure/components/chicken.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/custom_hitbox.dart';
import 'package:pixel_adventure/components/fruit.dart';
import 'package:pixel_adventure/components/saw.dart';
import 'package:pixel_adventure/components/utils.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum PlayerState {
  idle,
  running,
  jumping,
  doubleJumping,
  wallJumping,
  wallIdle,
  falling,
  hit,
  appearing,
  disappearing
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler, CollisionCallbacks {
  Player({
    position,
    //this.character = "Ninja Frog", // default character
    required this.character,
  }) : super(position: position, priority: 1);
  Character character;

  final double stepTime = 0.05;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation doubleJumpAnimation;
  late final SpriteAnimation wallJumpingAnimation;
  late final SpriteAnimation wallIdleAnimation;
  late final SpriteAnimation fallingAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation appearingAnimation;
  late final SpriteAnimation disappearingAnimation;

  final double _gravity = 9.8;
  final double _jumpForce = 260;
  final double _terminalVelocity = 300;
  int jumpCount = 0;
  int maxJumpps = 2;
  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 startingPosition = Vector2.zero();
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool isOnWall = false;
  bool hasJumped = false;
  bool gotHit = false;
  bool reachedCheckpoint = false;
  List<CollisionBlock> collisionBlocks = [];

  CustomHitbox hitbox = CustomHitbox(
    offsetX: 10,
    offsetY: 4,
    width: 14,
    height: 28,
  );

  double fixedDeltaTime = 1 / 60; // targeting 60fps
  double accumulatedTime = 0;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    //debugMode = true;
    startingPosition = Vector2(position.x, position.y);
    add(RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height)));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;

    while (accumulatedTime >= fixedDeltaTime) {
      if (!gotHit && !reachedCheckpoint) {
        _updatePlayerState();
        _updatePlayerMovement(fixedDeltaTime);
        _checkHorizontalCollisions(fixedDeltaTime);
        _applyGravity(fixedDeltaTime);
        _checkVerticalCollisions();
      }
      accumulatedTime -= fixedDeltaTime;
    }
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);

    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    hasJumped = keysPressed.contains(LogicalKeyboardKey.space);

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (!reachedCheckpoint) {
      if (other is Fruit) other.collidedWithPlayer();
      if (other is Saw) {
        _respawn();
        game.gameManager.loseLife();
      }
      if (other is Chicken) other.collidedWithPlayer();
      if (other is Checkpoint && !reachedCheckpoint) _reachedCheckpoint();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 12);
    jumpingAnimation = _spriteAnimation('Jump', 1);
    fallingAnimation = _spriteAnimation('Fall', 1);
    doubleJumpAnimation = _spriteAnimation('Double Jump', 6);
    wallJumpingAnimation = _spriteAnimation('Double Jump', 5);
    wallIdleAnimation = _spriteAnimation('Wall Jump', 5);
    hitAnimation = _spriteAnimation('Hit', 7)..loop = false;
    appearingAnimation = _specialSpriteAnimation('Appearing', 7);
    disappearingAnimation = _specialSpriteAnimation('Disappearing', 7);

    // List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.doubleJumping: doubleJumpAnimation,
      PlayerState.wallJumping: wallJumpingAnimation,
      PlayerState.wallIdle: wallIdleAnimation,
      PlayerState.falling: fallingAnimation,
      PlayerState.hit: hitAnimation,
      PlayerState.appearing: appearingAnimation,
      PlayerState.disappearing: disappearingAnimation,
    };

    // Set current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images
            .fromCache('Main Characters/${character.name}/$state (32x32).png'),
        SpriteAnimationData.sequenced(
          amount: amount,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
        ));
  }

  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$state (96x96).png'),
        SpriteAnimationData.sequenced(
          amount: amount,
          stepTime: stepTime,
          textureSize: Vector2.all(96),
          loop: false,
        ));
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;
    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    // check if moving, set to running
    if (velocity.x != 0) playerState = PlayerState.running;

    // check if falling, set to falling
    if (velocity.y > 0) {
      if (!isOnWall) {
        playerState = PlayerState.falling;
      } else {
        playerState = PlayerState.wallIdle;
      }
    }

    // check if jumping, set to jumping
    if (velocity.y < 0) {
      if (jumpCount == maxJumpps || isOnWall) {
        playerState = PlayerState.doubleJumping;
      } else {
        playerState = PlayerState.jumping;
      }
    }

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    // if (hasJumped && isOnWall) {
    //   jumpCount = 0;
    //   _playerJump(dt);
    // }
    if (hasJumped && ((isOnGround || isOnWall) || (velocity.y != 0 && jumpCount < maxJumpps))) {
      _playerJump(dt);
    }

    // optional to prevent jumping when falling (NOT from jumping)
    //if (velocity.y > _gravity) isOnGround = false;

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    if (game.playSounds) FlameAudio.play('jump.wav', volume: game.soundVolume);
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    jumpCount++;
    isOnGround = false;
    hasJumped = false;
  }

  void _checkHorizontalCollisions(double dt) {
    for (final block in collisionBlocks) {
      // handle collision
      if (!block.isPlatform) {
        if (block.isWall) {
          if (checkCollision(this, block)) {
            // going right
            if (velocity.x > 0) {
              velocity.x = 0;
              position.x = block.x - hitbox.offsetX - hitbox.width;
              isOnWall = true;
              jumpCount = 0;
              break;
            }
            // going left
            if (velocity.x < 0) {
              velocity.x = 0;
              position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
              isOnWall = true;
              jumpCount = 0;
              break;
            }
          }
          // need to revert back after touching a wall
          //jumpCount = 0;
          isOnWall = false;
        } else {
          if (checkCollision(this, block)) {
            // going right
            if (velocity.x > 0) {
              velocity.x = 0;
              position.x = block.x - hitbox.offsetX - hitbox.width;
              break;
            }
            // going left
            if (velocity.x < 0) {
              velocity.x = 0;
              position.x =
                  block.x + block.width + hitbox.width + hitbox.offsetX;
              break;
            }
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    if (velocity.y > 0 && isOnWall) {
      velocity.y += _gravity / 5;
    } else {
      velocity.y += _gravity;
    }
    velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        // handle platforms
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            jumpCount = 0;
            break;
          }
        }
      } else {
        if (checkCollision(this, block)) {
          // we're falling
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            jumpCount = 0;
            break;
          }
          // going up
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
          }
        }
      }
    }
  }

  void _respawn() async {
    if (game.playSounds) FlameAudio.play('hit.wav', volume: game.soundVolume);
    const canMoveDuration = Duration(milliseconds: 200); // random value
    gotHit = true;
    current = PlayerState.hit;

    await animationTicker?.completed;
    animationTicker?.reset();

    scale.x = 1; // always face the right

    // 96 - 64 (appearing animation is greater than player animation)
    position = startingPosition - Vector2.all(32);
    current = PlayerState.appearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    velocity = Vector2.zero();
    position = startingPosition;

    _updatePlayerState();
    current = PlayerState.idle;
    Future.delayed(canMoveDuration, () => gotHit = false);
  }

  void _reachedCheckpoint() async {
    if (game.playSounds) {
      FlameAudio.play('disappear.wav', volume: game.soundVolume);
    }
    reachedCheckpoint = true;
    if (scale.x > 0) {
      // facing to the right
      position = position - Vector2.all(32);
    } else if (scale.x < 0) {
      // facing to the left
      position = position + Vector2(32, -32);
    }

    current = PlayerState.disappearing;

    await animationTicker?.completed;
    animationTicker?.reset();

    reachedCheckpoint = false;
    position = Vector2.all(-640); // off screen

    const waitToChangeDuration = Duration(seconds: 3);
    Future.delayed(waitToChangeDuration, () {
      // switch level
      game.loadNextLevel();
    });
  }

  void collidedWithEnemy() {
    if (game.gameManager.livesRemaining.value == 0) {
      game.onLose();
    } else {
      game.gameManager.loseLife();
      _respawn();
    }
  }
}
