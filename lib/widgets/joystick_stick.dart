import 'package:flutter/material.dart';

class MyJoystickStick extends StatelessWidget {
  final double size;

  const MyJoystickStick({
    this.size = 50,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black,
        //     spreadRadius: 5,
        //     blurRadius: 7,
        //     offset: Offset(0, 3),
        //   )
        // ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black,
            Colors.black
          ],
        ),
      ),
    );
  }
}