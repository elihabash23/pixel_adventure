import 'package:flutter/material.dart';

class LevelButton extends StatelessWidget {
  const LevelButton(
      {super.key,
      this.selected = false,
      required this.number,
      required this.image,
      this.onSelectLevel});

  final bool selected;
  final int number;
  final String image;
  final void Function()? onSelectLevel;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: (!selected)
          ? FilledButton.styleFrom(backgroundColor: Colors.transparent)
          : FilledButton.styleFrom(backgroundColor: Colors.green),
      onPressed: onSelectLevel,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
        child: Column(
          children: [
            Image.asset(
              image,
              height: 60,
              width: 60,
            ),
          ],
        ),
      ),
    );
  }
}
