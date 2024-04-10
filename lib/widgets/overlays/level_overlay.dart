import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/widgets/buttons/level_button.dart';

class LevelOverlay extends StatefulWidget {
  const LevelOverlay(this.game, {super.key});

  final Game game;

  @override
  State<LevelOverlay> createState() => _LevelOverlayState();
}

class _LevelOverlayState extends State<LevelOverlay> {
  List levels = [];
  int count = -1;

  @override
  Widget build(BuildContext context) {
    PixelAdventure game = widget.game as PixelAdventure;

    return Material(
      color: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Levels',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(),
            ),
            const WhiteSpace(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              // Pick Level
              children: [
                for (var i in game.levelManager.levels.keys)
                  LevelButton(
                    number: i,
                    image: "assets/images/Menu/Levels/01.png",
                    selected: count == i,
                    onSelectLevel: () {
                    setState(() {
                      // Set the level
                      count = i;
                    });
                  })
              ],
            ),
            const WhiteSpace(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () async {
                game.levelManager.selectLevel(count);
                game.startGame();
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(
                  const Size(200, 75),
                ),
                textStyle: MaterialStateProperty.all(
                    Theme.of(context).textTheme.titleLarge),
              ),
              child: const Text('Play'),
            ),
          ],
        ),
      ),
    );
  }
}
