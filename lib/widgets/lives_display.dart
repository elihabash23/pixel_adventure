import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class LivesDisplay extends StatelessWidget {
  const LivesDisplay({super.key, required this.game, this.isLight = false});

  final Game game;
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: (game as PixelAdventure).gameManager.livesRemaining,
      builder: (context, value, child) {
        return Text(
          'Lives: $value',
          style: Theme.of(context).textTheme.displaySmall!,
        );
      },
    );
  }
}
