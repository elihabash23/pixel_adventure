import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/constants/asset_paths.dart';
import 'package:pixel_adventure/constants/game_constants.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/widgets/buttons/animated_game_button.dart';
import 'package:pixel_adventure/widgets/buttons/character_button.dart';
import 'package:pixel_adventure/widgets/white_space.dart';

class MainMenuOverlay extends StatefulWidget {
  const MainMenuOverlay(this.game, {super.key});

  final Game game;

  @override
  State<MainMenuOverlay> createState() => _MainMenuOverlayState();
}

class _MainMenuOverlayState extends State<MainMenuOverlay> {
  Character character = Character.ninjaFrog;

  @override
  void initState() {
    super.initState();
    // Load last selected character if available
    final game = widget.game as PixelAdventure;
    if (game.saveManager.isInitialized) {
      final lastCharacter = game.saveManager.getLastSelectedCharacter();
      if (lastCharacter != null) {
        try {
          character = Character.values.firstWhere(
            (c) => c.name == lastCharacter,
            orElse: () => Character.ninjaFrog,
          );
        } catch (e) {
          // If parsing fails, keep default
          character = Character.ninjaFrog;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    PixelAdventure game = widget.game as PixelAdventure;
    final int highScore = game.saveManager.getHighScore();

    return LayoutBuilder(
      builder: (context, constraints) {
        final characterWidth = constraints.maxWidth / 10;
        final bool screenHeightIsSmall = constraints.maxHeight < LayoutConstants.smallScreenHeight;

        return Material(
          color: Colors.amber,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Pixel Adventure',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w100,
                          fontFamily: 'MinecraftEvenings',
                          fontSize: 50),
                      textAlign: TextAlign.center,
                    ),
                    const WhiteSpace(
                      height: 10,
                    ),
                    if (highScore > 0)
                      Text(
                        'High Score: $highScore',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 50, 50, 50),
                            fontWeight: FontWeight.w100,
                            fontFamily: 'MinecraftEvenings',
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    const WhiteSpace(
                      height: 20,
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Choose Your Character: ",
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w100,
                            fontFamily: 'MinecraftEvenings',
                            fontSize: 30),
                      ),
                    ),
                    if (!screenHeightIsSmall) const WhiteSpace(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CharacterButton(
                          character: Character.ninjaFrog,
                          selected: character == Character.ninjaFrog,
                          onSelectChar: () {
                            setState(() {
                              character = Character.ninjaFrog;
                            });
                          },
                          characterWidth: characterWidth,
                        ),
                        CharacterButton(
                          character: Character.maskDude,
                          selected: character == Character.maskDude,
                          onSelectChar: () {
                            setState(() {
                              character = Character.maskDude;
                            });
                          },
                          characterWidth: characterWidth,
                        ),
                        CharacterButton(
                          character: Character.pinkMan,
                          selected: character == Character.pinkMan,
                          onSelectChar: () {
                            setState(() {
                              character = Character.pinkMan;
                            });
                          },
                          characterWidth: characterWidth,
                        ),
                        CharacterButton(
                          character: Character.virtualGuy,
                          selected: character == Character.virtualGuy,
                          onSelectChar: () {
                            setState(() {
                              character = Character.virtualGuy;
                            });
                          },
                          characterWidth: characterWidth,
                        ),
                      ],
                    ),
                    if (!screenHeightIsSmall) const WhiteSpace(height: 50),
                    Center(
                      child: AnimatedGameButton(
                        width: 250,
                        height: 70,
                        backgroundColor: const Color(0xFF4CAF50), // Bright green
                        foregroundColor: Colors.white,
                        onPressed: () async {
                          game.gameManager.selectCharacter(character);
                          // Save character selection
                          if (game.saveManager.isInitialized) {
                            game.saveManager.saveLastSelectedCharacter(character.name);
                          }
                          // Log character selection
                          game.analytics.logCharacterSelected(character.name);
                          game.setLevel();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'START!',
                              style: TextStyle(
                                fontFamily: 'MinecraftEvenings',
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Image.asset(
                              AssetPaths.nextButton,
                              height: 40,
                              width: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class LevelPicker extends StatelessWidget {
  const LevelPicker({
    super.key,
    required this.level,
    required this.label,
    required this.onChanged,
  });

  final double level;
  final String label;
  final void Function(double) onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Slider(
      value: level,
      max: 5,
      min: 1,
      divisions: 4,
      label: label,
      onChanged: onChanged,
    ));
  }
}
