import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/managers/game_manager.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/widgets/buttons/animated_game_button.dart';

class TheEndOverlay extends StatelessWidget {
  const TheEndOverlay(this.game, {super.key});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final pixelGame = game as PixelAdventure;
    final score = pixelGame.gameManager.score.value;

    return Material(
      color: const Color(0xFFFFD700), // Bright gold background
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Celebration message
              const Text(
                "YOU WIN!",
                style: TextStyle(
                  color: Color(0xFF6B4DB8),
                  fontWeight: FontWeight.w100,
                  fontFamily: 'MinecraftEvenings',
                  fontSize: 40,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black26,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),

              // Final score display
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Score: ',
                      style: TextStyle(
                        color: Color(0xFF6B4DB8),
                        fontFamily: 'MinecraftEvenings',
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      '$score',
                      style: const TextStyle(
                        color: Color(0xFFFFD700),
                        fontFamily: 'MinecraftEvenings',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Main Menu Button
              AnimatedGameButton(
                width: 220,
                height: 55,
                backgroundColor: const Color(0xFF4CAF50), // Green
                foregroundColor: Colors.white,
                onPressed: () {
                  pixelGame.gameManager.state = GameState.intro;
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home, size: 28),
                    SizedBox(width: 8),
                    Text(
                      'Play Again!',
                      style: TextStyle(
                        fontFamily: 'MinecraftEvenings',
                        fontSize: 22,
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
    );
  }
}
