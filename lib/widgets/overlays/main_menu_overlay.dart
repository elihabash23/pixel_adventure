import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class MainMenuOverlay extends StatefulWidget {
  const MainMenuOverlay(this.game, {super.key});

  final Game game;

  @override
  State<MainMenuOverlay> createState() => _MainMenuOverlayState();
}

class _MainMenuOverlayState extends State<MainMenuOverlay> {
  Character character = Character.ninjaFrog;

  @override
  Widget build(BuildContext context) {
    PixelAdventure game = widget.game as PixelAdventure;

    return LayoutBuilder(
      builder: (context, constraints) {
        final characterWidth = constraints.maxWidth / 5;
        final TextStyle titleStyle = (constraints.maxWidth > 830)
            ? Theme.of(context).textTheme.displayLarge!
            : Theme.of(context).textTheme.displaySmall!;

        // 760 is the smallest height the browser can have until the
        // layout is too large to fit.
        final bool screenHeightIsSmall = constraints.maxHeight < 760;

        return Material(
          color: Theme.of(context).colorScheme.background,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Pixel Adventure',
                      style: titleStyle.copyWith(
                        height: .8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const WhiteSpace(),
                    Align(
                      alignment: Alignment.center,
                      child: Text("Choose your Character: ",
                          style: Theme.of(context).textTheme.headlineSmall!),
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
                      ],
                    ),
                    if (!screenHeightIsSmall) const WhiteSpace(height: 50),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          game.gameManager.selectCharacter(character);
                          game.setLevel();
                        },
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                            const Size(100, 50),
                          ),
                          textStyle: MaterialStateProperty.all(
                              Theme.of(context).textTheme.titleLarge),
                        ),
                        child: const Text('Next'),
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

class CharacterButton extends StatelessWidget {
  const CharacterButton(
      {super.key,
      required this.character,
      this.selected = false,
      required this.onSelectChar,
      required this.characterWidth});

  final Character character;
  final bool selected;
  final void Function() onSelectChar;
  final double characterWidth;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: (selected)
          ? ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(31, 64, 195, 255)))
          : null,
      onPressed: onSelectChar,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.asset(
              'assets/images/Main Characters/${character.name}/Jump (32x32).png',
              height: characterWidth,
              width: characterWidth,
            ),
            const WhiteSpace(height: 18),
            Text(
              character.name,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class WhiteSpace extends StatelessWidget {
  const WhiteSpace({super.key, this.height = 100});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
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
