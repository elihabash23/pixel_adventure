import 'package:flutter/material.dart';
import 'package:pixel_adventure/constants/asset_paths.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/widgets/white_space.dart';

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
    return FilledButton(
      style: (!selected)
          ? FilledButton.styleFrom(backgroundColor: Colors.transparent)
          : FilledButton.styleFrom(backgroundColor: Colors.green),
      onPressed: onSelectChar,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Image.asset(
              AssetPaths.getCharacterJumpImage(character.name),
              height: 50,
              width: 50,
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