import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class LevelDisplay extends StatelessWidget {
  const LevelDisplay({super.key, required this.game, this.isLight = false});

  final Game game;
  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: (game as PixelAdventure).levelManager.currentLevel,
      builder: (context, value, child) {
        return Text(
          'Level: $value',
          style: Theme.of(context).textTheme.displaySmall!,
        );
      },
    );
  }
}