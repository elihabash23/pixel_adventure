import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:pixel_adventure/components/player.dart';
// import 'package:pixel_adventure/widgets/ball.dart';
// import 'package:pixel_adventure/widgets/ball.dart';
// import 'package:pixel_adventure/widgets/joystick_mode_dropdown.dart';

class JoystickExample extends StatefulWidget {
  const JoystickExample(this.player, {Key? key}) : super(key: key);

  final Player player;

  @override
  State<JoystickExample> createState() => _JoystickExampleState();
}

class _JoystickExampleState extends State<JoystickExample> {
  // double _x = 100;
  // double _y = 100;
  final ballSize = 20.0;
  final step = 10.0;
  // final JoystickMode _joystickMode = JoystickMode.all;

  // @override
  // void didChangeDependencies() {
  //   _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return Joystick(
      base: const JoystickBase(
        mode: JoystickMode.all,
        size: 100,
        color: Color(0x50616161),
        drawArrows: false,
      ),
      stick: const JoystickStick(
        size: 35,
      ),
      period: const Duration(milliseconds: 1),
      listener: (details) {
        setState(() {
          // _x = _x + step * details.x;
          // _y = _y + step * details.y;
          (widget.player).horizontalMovement = details.x;
        });
      },
    );
  }
}

// class _JoystickExampleState extends State<JoystickExample> {
//   double _x = 100;
//   double _y = 100;
//   JoystickMode _joystickMode = JoystickMode.all;
//   final step = 10.0;
//   final ballSize = 20.0;

//   @override
//   void didChangeDependencies() {
//     _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green,

//       body: SafeArea(
//         child: Stack(
//           children: [
//             Container(
//               color: Colors.green,
//             ),
//             Ball(_x, _y),
//             Align(
//               alignment: const Alignment(0, 0.8),
//               child: Joystick(
//                 mode: _joystickMode,
//                 listener: (details) {
//                   setState(() {
//                     _x = _x + step * details.x;
//                     _y = _y + step * details.y;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
