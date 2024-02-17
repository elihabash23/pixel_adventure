import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
// import 'package:flame/input.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class JumpButton extends SpriteComponent
    with HasGameRef<PixelAdventure>, TapCallbacks {
  JumpButton();

  //final margin = const EdgeInsets.only(right: 40, bottom: 40);
  final margin = 32;
  final buttonSize = 64;
  //final buttonSize = Vector2.all(80);

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    sprite = Sprite(game.images.fromCache('HUD/JumpButton.png'));
    position = Vector2(
      game.size.x - margin - buttonSize,
      game.size.y - margin - buttonSize,
    );
    
    // position = Vector2(margin.right, margin.bottom);

    //   final flipButton = HudButtonComponent(
    //   button: SpriteComponent(
    //     sprite: Sprite(game.images.fromCache('HUD/JumpButton.png')),
    //     size: buttonSize,
    //   ),

    //   margin: const EdgeInsets.only(
    //     right: 80,
    //     bottom: 60,
    //   ),
    // );
    priority = 10;
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.hasJumped = true;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.player.hasJumped = false;
    super.onTapUp(event);
  }
}
