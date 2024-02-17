import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/widgets/game_over_overlay.dart';
import 'package:pixel_adventure/widgets/game_overlay.dart';
import 'package:pixel_adventure/widgets/main_menu_overlay.dart';

PixelAdventure game = PixelAdventure();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  //PixelAdventure game = PixelAdventure();
  runApp(
    //GameWidget(game: kDebugMode ? PixelAdventure() : game),
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
      body: Center(
        child: LayoutBuilder(builder: (context, constraints) {
          return Container(
            constraints: const BoxConstraints(
              minWidth: 550,
              maxWidth: 800
            ),
            child: GameWidget(
              game: kDebugMode ? PixelAdventure() : game,
              overlayBuilderMap: <String, Widget Function(BuildContext, Game)> {
                'mainMenuOverlay': (context, game) => MainMenuOverlay(game),
                'gameOverlay': (context, game) => GameOverlay(game),
                'gameOverOverlay': (context, game) => GameOverOverlay(game),
              }
            ),
          );
        }),
      ),
    );
  }
}
