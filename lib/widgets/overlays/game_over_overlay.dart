import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/widgets/buttons/animated_game_button.dart';

// class GameOverOverlay extends StatelessWidget {
//   const GameOverOverlay(this.game, {super.key});

//   final Game game;

//   @override
//   Widget build(BuildContext context) {
//     // Construct the main widget tree
//     final mainContent = Center(
//       child: Padding(
//         padding: const EdgeInsets.all(48),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               'Game Over',
//               style: Theme.of(context).textTheme.displayMedium!.copyWith(),
//             ),
//             const WhiteSpace(height: 50),
//             ScoreDisplay(
//               game: game,
//               isLight: true,
//             ),
//             const WhiteSpace(
//               height: 50,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 (game as PixelAdventure).resetGame();
//               },
//               style: ButtonStyle(
//                 minimumSize: MaterialStateProperty.all(
//                   const Size(200, 75),
//                 ),
//                 textStyle: MaterialStateProperty.all(
//                     Theme.of(context).textTheme.titleLarge),
//               ),
//               child: Image.asset(
//                 'assets/images/Menu/Buttons/Restart.png',
//                 height: 40,
//                 width: 40,
//               ),
//             ),
//             const WhiteSpace(
//               height: 25,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 (game as PixelAdventure).quitGame();
//               },
//               style: ButtonStyle(
//                 minimumSize: MaterialStateProperty.all(
//                   const Size(200, 75),
//                 ),
//                 textStyle: MaterialStateProperty.all(
//                     Theme.of(context).textTheme.titleLarge),
//               ),
//               child: const Text('Main Menu'),
//             ),
//           ],
//         ),
//       ),
//     );

//     // Debug print the widget tree
//     debugPrint(mainContent.toStringDeep());

//     return Material(
//       color: Theme.of(context).colorScheme.background,
//       child: mainContent,
//     );
//   }
// }

class GameOverOverlay extends StatelessWidget {
  const GameOverOverlay(this.game, {super.key});

  final Game game;

  // List of encouraging messages for kids
  static const List<String> _encouragingMessages = [
    "Nice Try! 🌟",
    "Almost There! 💪",
    "Keep Going! 🚀",
    "You Can Do It! ⭐",
    "Don't Give Up! 🎮",
    "Try Again! 🎯",
  ];

  String _getEncouragingMessage() {
    final random = DateTime.now().millisecond % _encouragingMessages.length;
    return _encouragingMessages[random];
  }

  @override
  Widget build(BuildContext context) {
    final pixelGame = game as PixelAdventure;
    final score = pixelGame.gameManager.score.value;

    return Material(
      color: const Color(0xFF6B4DB8), // Fun purple background
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Encouraging message
              Text(
                _getEncouragingMessage(),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'MinecraftEvenings',
                  fontSize: 36,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black45,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Score display
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
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
                child: Text(
                  'Score: $score',
                  style: const TextStyle(
                    color: Color(0xFF6B4DB8),
                    fontFamily: 'MinecraftEvenings',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Try Again Button
              AnimatedGameButton(
                width: 220,
                height: 50,
                backgroundColor: const Color(0xFFFFD700), // Gold
                foregroundColor: Colors.black,
                onPressed: () {
                  pixelGame.resetGame();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Menu/Buttons/Restart.png',
                      height: 28,
                      width: 28,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Try Again!',
                      style: TextStyle(
                        fontFamily: 'MinecraftEvenings',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Main Menu Button
              AnimatedGameButton(
                width: 220,
                height: 50,
                backgroundColor: const Color(0xFF4CAF50), // Green
                foregroundColor: Colors.white,
                onPressed: () {
                  pixelGame.quitGame();
                },
                child: const Text(
                  'Main Menu',
                  style: TextStyle(
                    fontFamily: 'MinecraftEvenings',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


