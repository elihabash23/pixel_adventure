import 'package:flutter/material.dart';

class LevelButton extends StatelessWidget {
  const LevelButton(
      {super.key,
      this.selected = false,
      required this.number,
      required this.image,
      required this.onSelectLevel});

  final bool selected;
  final int number;
  final String image;
  final void Function() onSelectLevel;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: (selected)
          ? ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(31, 64, 195, 255)))
          : null,
      onPressed: onSelectLevel,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.asset(
              image,
              height: 30,
              width: 30,
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
