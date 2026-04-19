import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/widgets/overlays/game_over_overlay.dart';
import 'package:pixel_adventure/widgets/overlays/game_overlay.dart';
import 'package:pixel_adventure/widgets/overlays/level_overlay.dart';
import 'package:pixel_adventure/widgets/overlays/main_menu_overlay.dart';
import 'package:pixel_adventure/widgets/overlays/pause_overlay.dart';
import 'package:pixel_adventure/widgets/overlays/the_end_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(
    const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixel Adventure',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        // colorScheme: lightColorScheme,
        useMaterial3: true

      ),
      home: const MyHomePage(title: "Pixel Adventure"),
    );
  }
}

class MyHomePage extends StatefulWidget{
  const MyHomePage({super.key, required String title});
  
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 194, 0), // Match game background
      body: SafeArea(
        child: GameWidget(
          game: PixelAdventure(),
          overlayBuilderMap: <String, Widget Function(BuildContext, Game)> {
            'mainMenuOverlay': (context, game) => MainMenuOverlay(game),
            'gameOverlay': (context, game) => GameOverlay(game),
            'gameOverOverlay': (context, game) => GameOverOverlay(game),
            'levelOverlay': (context, game) => LevelOverlay(game),
            'pauseOverlay': (context, game) => PauseOverlay(game),
            'theEndOverlay': (context, game) => TheEndOverlay(game),
          }
        ),
      ),
    );
  }
}
