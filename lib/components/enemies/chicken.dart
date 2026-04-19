import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/constants/asset_paths.dart';
import 'package:pixel_adventure/constants/game_constants.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum State { idle, run, hit }

class Chicken extends SpriteAnimationGroupComponent
    with HasGameReference<PixelAdventure>, CollisionCallbacks {
  final double offNeg;
  final double offPos;
  Chicken({
    super.position,
    super.size,
    this.offNeg = 0,
    this.offPos = 0,
  });

  static const stepTime = AnimationConstants.stepTime;
  static const tileSize = CollisionConstants.tileSize;
  static const runSpeed = EnemyConstants.chickenRunSpeed;
  static const _bounceHeight = GamePhysics.chickenBounceHeight;
  final textureSize = Vector2(32, 34);

  Vector2 velocity = Vector2.zero();
  double rangeNeg = 0;
  double rangePos = 0;
  double moveDirection = 1;
  double targetDirection = -1;
  bool gotStomped = false;

  late final Player player;
  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _runAnimation;
  late final SpriteAnimation _hitAnimation;

  // Called once when the component is first added to the game.
  // Grabs a reference to the player, adds the hitbox (offset inward from the
  // sprite edges), then loads animations and calculates the patrol range.
  @override
  FutureOr<void> onLoad() {
    player = game.player;

    add(RectangleHitbox(
      position: Vector2(4, 6),
      size: Vector2(24, 26),
    ));
    _loadAllAnimations();
    _calculateRange();
    return super.onLoad();
  }

  // Called every frame. Skips all logic if the chicken has been stomped
  // (so the hit animation can finish playing before removal).
  // [dt] is the time elapsed since the last frame in seconds.
  @override
  void update(double dt) {
    if (!gotStomped) {
      _updateState();
      _movement(dt);
    }
    super.update(dt);
  }

  // Loads the three sprite animations (idle, run, hit) from the image cache
  // and registers them in the animations map keyed by State enum values.
  // Starts in the idle state.
  void _loadAllAnimations() {
    _idleAnimation = _spriteAnimation('Idle', 13);
    _runAnimation = _spriteAnimation('Run', 14);
    _hitAnimation = _spriteAnimation('Hit', 5)..loop = false;

    animations = {
      State.idle: _idleAnimation,
      State.run: _runAnimation,
      State.hit: _hitAnimation,
    };

    current = State.idle;
  }

  // Builds a SpriteAnimation from a sprite sheet in the Enemies/Chicken folder.
  // [state] is the animation name used in the filename (e.g. 'Idle', 'Run').
  // [amount] is the number of frames in that animation strip.
  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Chicken/$state (32x34).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: textureSize,
      ),
    );
  }

  // Converts the offNeg/offPos tile counts (set in Tiled) into world-space
  // x coordinates. rangeNeg is the left boundary, rangePos is the right
  // boundary of the chicken's patrol/chase zone.
  void _calculateRange() {
    rangeNeg = position.x - offNeg * tileSize;
    rangePos = position.x + offPos * tileSize;
  }

  // Handles horizontal movement each frame.
  // If the player is within range, sets targetDirection toward the player
  // and applies runSpeed. If out of range, velocity stays 0 (idle).
  // moveDirection is lerped toward targetDirection to smooth out the flip.
  // [dt] is the time elapsed since the last frame in seconds.
  void _movement(dt) {
    velocity.x = 0;

    // Accounts for the player's flipped scale so the reference point is
    // always the player's visible left edge regardless of facing direction.
    double playerOffSet = (player.scale.x > 0) ? 0 : -player.width;
    // Same adjustment for the chicken itself.
    double chickenOffset = (scale.x > 0) ? 0 : -width;

    if (playerInRange()) {
      targetDirection =
          (player.x + playerOffSet < position.x + chickenOffset) ? -1 : 1;
      velocity.x = targetDirection * runSpeed;
    }

    // Smoothly interpolate moveDirection toward targetDirection (10% per frame)
    // so the sprite flip doesn't happen instantly and looks more natural.
    moveDirection = lerpDouble(moveDirection, targetDirection, 0.1) ?? 1;

    position.x += velocity.x * dt;
  }

  // Returns true if the player's x position falls within the chicken's patrol
  // range AND the player is vertically overlapping (same height band).
  // The playerOffSet correction handles the flipped-scale edge case.
  bool playerInRange() {
    double playerOffSet = (player.scale.x > 0) ? 0 : -player.width;

    return player.x + playerOffSet >= rangeNeg &&
        player.x + playerOffSet <= rangePos &&
        player.y + player.height > position.y &&
        player.y < position.y + height;
  }

  // Switches between idle and run animations based on horizontal velocity,
  // and flips the sprite horizontally when moveDirection and scale disagree
  // (i.e. the chicken needs to face the other way).
  void _updateState() {
    current = (velocity.x != 0) ? State.run : State.idle;

    if ((moveDirection > 0 && scale.x > 0) ||
        (moveDirection < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }

  // Called by the player when a collision with this chicken is detected.
  // If the player is falling (velocity.y > 0) and above the chicken's top
  // edge, it counts as a stomp: plays a sound, bounces the player upward,
  // plays the hit animation, then removes the chicken from the game.
  // Otherwise the player takes damage via collidedWithEnemy().
  void collidedWithPlayer() async {
    if (player.velocity.y > 0 && player.y + player.height > position.y) {
      if (game.playSounds) {
        FlameAudio.play(AssetPaths.hitEnemySound, volume: game.soundVolume);
      }
      gotStomped = true;
      current = State.hit;
      player.velocity.y = -_bounceHeight;
      if (animationTicker != null) {
        await animationTicker!.completed;
      }
      removeFromParent();
    } else {
      player.collidedWithEnemy();
    }
  }
}
