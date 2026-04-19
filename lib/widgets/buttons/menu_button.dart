import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton(
      {super.key,
      this.selected = false,
      required this.number,
      required this.image,
      required this.onSelect});

  final bool selected;
  final int number;
  final String image;
  final void Function() onSelect;
  
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: (!selected)
          ? FilledButton.styleFrom(backgroundColor: Colors.transparent)
          : FilledButton.styleFrom(backgroundColor: Colors.green),
      onPressed: onSelect,
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