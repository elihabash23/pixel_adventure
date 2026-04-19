import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/constants/asset_paths.dart';
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
            top: 15,
            right: 30,
            child: FilledButton( // Pause Button
                onPressed: () {
                  (widget.game as PixelAdventure).togglePauseState();
                  setState(() {
                    isPaused = !isPaused;
                  });
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                child: isPaused
                    ? Image.asset(
                        AssetPaths.closeButton,
                        height: 48,
                        width: 48,
                      )
                    : Image.asset(
                        AssetPaths.pauseButton,
                        height: 48,
                        width: 48,
                      )),
          ),
          // Only show on-screen controls on mobile platforms
          if ((widget.game as PixelAdventure).showControls)
            Positioned.fill(
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 25,
                      right: 0,
                      child: FilledButton( // Jump Button
                          onPressed: () {
                            (widget.game as PixelAdventure).pressJump();
                          },
                          style: FilledButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              enableFeedback: false),
                          child: Image.asset(
                            AssetPaths.jumpButton,
                            height: 68,
                            width: 48,
                          )),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      child: JoystickExample((widget.game as PixelAdventure).player),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
