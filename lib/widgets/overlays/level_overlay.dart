import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/constants/asset_paths.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/widgets/buttons/animated_game_button.dart';
import 'package:pixel_adventure/widgets/buttons/level_button.dart';
import 'package:pixel_adventure/widgets/white_space.dart';

class LevelOverlay extends StatefulWidget {
  const LevelOverlay(this.game, {super.key});

  final Game game;

  @override
  State<LevelOverlay> createState() => _LevelOverlayState();
}

class _LevelOverlayState extends State<LevelOverlay> {
  List levels = [];
  int? count;

  @override
  Widget build(BuildContext context) {
    PixelAdventure game = widget.game as PixelAdventure;

    return Material(
      color: Colors.amber,
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Choose Your Level!',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w100,
                      fontFamily: 'MinecraftEvenings',
                      fontSize: 36),
                ),
                const WhiteSpace(
                  height: 20,
                ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              // Pick Level
              children: [
                for (var i in game.levelManager.levels.keys)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: game.saveManager.isLevelUnlocked(i) ? 1.0 : 0.5,
                        child: LevelButton(
                          selected: count == i,
                          number: i,
                          image: AssetPaths.getLevelImage(i),
                          onSelectLevel: game.saveManager.isLevelUnlocked(i)
                              ? () {
                                  setState(
                                    () {
                                      // Set the level
                                      count = i;
                                    },
                                  );
                                }
                              : null,
                        ),
                      ),
                      // Lock icon for locked levels
                      if (!game.saveManager.isLevelUnlocked(i))
                        const Icon(
                          Icons.lock,
                          size: 40,
                          color: Colors.black54,
                        ),
                    ],
                  )
              ],
            ),
                const WhiteSpace(
                  height: 20,
                ),
                AnimatedGameButton(
                  width: 200,
                  height: 55,
                  backgroundColor: count != null ? const Color(0xFF4CAF50) : Colors.grey,
                  foregroundColor: Colors.white,
                  onPressed: count != null ? () async {
                    game.levelManager.selectLevel(count!);
                    game.startGame();
                  } : null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'PLAY!',
                        style: TextStyle(
                          fontFamily: 'MinecraftEvenings',
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        AssetPaths.nextButton,
                        height: 32,
                        width: 32,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
