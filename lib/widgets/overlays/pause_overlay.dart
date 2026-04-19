import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:pixel_adventure/constants/game_constants.dart';
import 'package:pixel_adventure/managers/game_manager.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/widgets/buttons/animated_game_button.dart';
import 'package:pixel_adventure/widgets/white_space.dart';

class PauseOverlay extends StatelessWidget {
  const PauseOverlay(this.game, {super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    PixelAdventure pixelGame = game as PixelAdventure;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool screenHeightIsSmall = constraints.maxHeight < LayoutConstants.smallScreenHeight;

        return Material(
          color: Colors.black87,
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Game Paused!',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'MinecraftEvenings',
                          fontSize: 50,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black45,
                              offset: Offset(3, 3),
                            ),
                          ]),
                      textAlign: TextAlign.center,
                    ),
                    if (!screenHeightIsSmall) const WhiteSpace(height: 50),
                    if (screenHeightIsSmall) const WhiteSpace(height: 30),

                    // Resume Button (bigger and brighter)
                    AnimatedGameButton(
                      width: 280,
                      height: 70,
                      backgroundColor: const Color(0xFF4CAF50), // Bright green
                      foregroundColor: Colors.white,
                      onPressed: () {
                        if (kDebugMode) {
                          print("Resuming game");
                        }
                        pixelGame.togglePauseState();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow, size: 36),
                          SizedBox(width: 10),
                          Text(
                            'Keep Playing!',
                            style: TextStyle(
                              fontFamily: 'MinecraftEvenings',
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const WhiteSpace(height: 20),

                    // Restart Level Button
                    AnimatedGameButton(
                      width: 280,
                      height: 70,
                      backgroundColor: const Color(0xFFFF9800), // Bright orange
                      foregroundColor: Colors.white,
                      onPressed: () {
                        if (kDebugMode) {
                          print("Restarting level");
                        }
                        // Resume first to unpause, then restart level
                        pixelGame.resumeEngine();
                        pixelGame.gameManager.state = GameState.playing;
                        pixelGame.restartLevel();
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.refresh, size: 36),
                          SizedBox(width: 10),
                          Text(
                            'Start Over',
                            style: TextStyle(
                              fontFamily: 'MinecraftEvenings',
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const WhiteSpace(height: 20),

                    // Main Menu Button
                    AnimatedGameButton(
                      width: 280,
                      height: 70,
                      backgroundColor: const Color(0xFFF44336), // Bright red
                      foregroundColor: Colors.white,
                      onPressed: () {
                        if (kDebugMode) {
                          print("Returning to main menu");
                        }
                        // Log return to main menu
                        pixelGame.analytics.logReturnToMainMenu('pause_overlay');
                        // Resume engine, reset game, and go to intro
                        pixelGame.resumeEngine();
                        pixelGame.quitGame();
                        pixelGame.gameManager.state = GameState.intro;
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home, size: 36),
                          SizedBox(width: 10),
                          Text(
                            'Main Menu',
                            style: TextStyle(
                              fontFamily: 'MinecraftEvenings',
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
