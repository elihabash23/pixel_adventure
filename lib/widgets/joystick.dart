import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/widgets/joystick_stick.dart';

class JoystickExample extends StatefulWidget {
  const JoystickExample(this.player, {Key? key}) : super(key: key);

  final Player player;

  @override
  State<JoystickExample> createState() => _JoystickExampleState();
}

class _JoystickExampleState extends State<JoystickExample> {
  @override
  Widget build(BuildContext context) {
    return Joystick(
      base: JoystickBase(
        mode: JoystickMode.all,
        size: 100,
        decoration: JoystickBaseDecoration(
          color: const Color(0x50616161),
          drawArrows: false,
        ),
      ),
      stick: const MyJoystickStick(
        size: 35,
      ),
      period: const Duration(milliseconds: 16), // ~60 FPS, matches game physics
      listener: (details) {
        // No setState needed - we're only updating game state, not UI
        widget.player.horizontalMovement = details.x;
      },
    );
  }
}
