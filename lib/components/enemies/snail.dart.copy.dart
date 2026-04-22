import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/constants/asset_paths.dart';
import 'package:pixel_adventure/constants/game_constants.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum SnailState { idle, walk, hit, shellIdle, shellWallHit, shellTopHit, snailWithoutShell }

class Snail extends SpriteAnimationGroupComponent
    with HasGameReference<PixelAdventure>, CollisionCallbacks {
  final double offNeg;
  final double offPos;

  Snail({
    super.position,
    super.size,
    this.offNeg = 0,
    this.offPos = 0,
  });

  static const stepTime = AnimationConstants.stepTime;
  static const tileSize = CollisionConstants.tileSize;
  static const _walkSpeed = EnemyConstants.snailWalkSpeed;
  static const _bounceHeight = GamePhysics.snailBounceHeight;

  final textureSize = Vector2(38, 24);

  late final Player _player;
  double _rangeNeg = 0;
  double _rangePos = 0;
  double _moveDirection = -1;
  bool gotStomped = false;
  bool _inShell = false;
  //bool _shellInvulnerable = false;
  //double _shellTimer = 0;

  @override
  FutureOr<void> onLoad() {
    _player = game.player;
    _rangeNeg = position.x - offNeg * tileSize;
    _rangePos = position.x + offPos * tileSize;

    add(RectangleHitbox(
      position: Vector2(4, 4),
      size: Vector2(30, 18),
    ));

    _loadAnimations();
    current = SnailState.walk;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (!_inShell) {
      _patrol(dt);
    } else {
      _updateShellTimer(dt);
    }
    super.update(dt);
  }

  void _loadAnimations() {
    animations = {
      SnailState.idle: _animation('Idle (38x24)', 10),
      SnailState.walk: _animation('Walk (38x24)', 10),
      SnailState.hit: _animation('Hit (38x24)', 5)..loop = false,
      SnailState.shellIdle: _animation('Shell Idle (38x24)', 5),
      SnailState.shellWallHit: _animation('Shell Wall Hit (38x24)', 5)..loop = false,
      SnailState.shellTopHit: _animation('Shell Top Hit (38x24)', 5)..loop = false,
      SnailState.snailWithoutShell: _animation('Snail without shell', 1)..loop = false,
    };
  }

  SpriteAnimation _animation(String name, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Snail/$name.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: textureSize,
      ),
    );
  }

  void _patrol(double dt) {
    if (position.x <= _rangeNeg) {
      _moveDirection = 1;
    } else if (position.x >= _rangePos) {
      _moveDirection = -1;
    }

    if (_moveDirection > 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (_moveDirection < 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    position.x += _moveDirection * _walkSpeed * dt;
    current = SnailState.walk;
  }

  // void _updateShellTimer(double dt) {
  //   if (_shellInvulnerable) {
  //     _shellTimer += dt;
  //     if (_shellTimer >= _shellInvulnerableDuration) {
  //       _inShell = false;
  //       _shellInvulnerable = false;
  //       _shellTimer = 0;
  //       current = SnailState.walk;
  //     } else {
  //       current = SnailState.shellIdle;
  //     }
  //   }
  // }

  // void collidedWithPlayer() {
  //   if (_player.velocity.y > 0 && _player.y + _player.height > position.y) {
  //     if (!_inShell) {
  //       _enterShell();
  //       _player.velocity.y = -GamePhysics.chickenBounceHeight;
  //     } else if (!_shellInvulnerable) {
  //       _die();
  //       _player.velocity.y = -GamePhysics.chickenBounceHeight;
  //     }
  //     // If shell is invulnerable, stomp is ignored
  //   } else {
  //     if (!_shellInvulnerable) {
  //       _player.collidedWithEnemy();
  //     }
  //   }
  // }

    void collidedWithPlayer() async{
    // _player.y = top of the _player
    // _player.height = bottom of the _player
    // falling
    if (_player.velocity.y > 0 && _player.y + _player.height > position.y) {
      // stomped on
      if (game.playSounds) {
        FlameAudio.play(AssetPaths.hitEnemySound, volume: game.soundVolume);
      }
      if (!_inShell){
        _enterShell();
        _player.velocity.y = -_bounceHeight;
      }
      gotStomped = true;
      current = SnailState.hit;
      
      if (animationTicker != null) {
        await animationTicker!.completed;
      }
      _die();
    } else {
      _player.collidedWithEnemy();
    }
  }


  void _enterShell() {
    _inShell = true;
    _shellInvulnerable = true;
    _shellTimer = 0;
    current = SnailState.hit;
    Future.delayed(
      Duration(milliseconds: (stepTime * 5 * 1000).toInt()),
      () {
        if (isMounted) current = SnailState.shellIdle;
      },
    );
  }

  void _die() {
    removeFromParent();
  }
}
