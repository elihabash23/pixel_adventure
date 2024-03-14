import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/widgets/displays/level_display.dart';
import 'package:pixel_adventure/widgets/joystick.dart';
import 'package:pixel_adventure/widgets/displays/lives_display.dart';
import 'package:pixel_adventure/widgets/displays/score_display.dart';

class GameOverlay extends StatefulWidget {
  const GameOverlay(this.game, {super.key});

  final Game game;

  @override
  State<GameOverlay> createState() => _GameOverlayState();
}

class _GameOverlayState extends State<GameOverlay> {
  bool isPaused = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            top: 30,
            left: 30,
            child: ScoreDisplay(game: widget.game),
          ),
          Positioned(
            top: 30,
            left: 200,
            child: LivesDisplay(game: widget.game),
          ),
          Positioned(
            top: 30,
            right: 200,
            child: LevelDisplay(game: widget.game),
          ),
          Positioned(
            top: 30,
            right: 30,
            child: ElevatedButton(
              onPressed: () {
                (widget.game as PixelAdventure).togglePauseState();
                setState(() {
                  isPaused = !isPaused;
                });
              },
              child: isPaused
                  ? const Icon(
                      Icons.play_arrow,
                      size: 48,
                    )
                  : const Icon(
                      Icons.pause,
                      size: 48,
                    ),
            ),
          ),
          Positioned(
            bottom: 30,
            right: 30,
            child: ElevatedButton(
                onPressed: () {
                  (widget.game as PixelAdventure).pressJump();
                },
                child: const Icon(
                  Icons.arrow_upward,
                  size: 48,
                )),
          ),
          Positioned(
              bottom: 30,
              left: 30,
              child: JoystickExample((widget.game as PixelAdventure).player)),
          if (isPaused)
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 72.0,
              right: MediaQuery.of(context).size.width / 2 - 72.0,
              child: const Icon(
                Icons.pause_circle,
                size: 144.0,
                color: Colors.black12,
              ),
            )
        ],
      ),
    );
  }
}
