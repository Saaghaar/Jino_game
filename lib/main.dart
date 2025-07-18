import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/flame.dart';

import 'package:runner_test1/game/game.dart';
import 'package:runner_test1/widget/pause_button_widget.dart';
import 'package:runner_test1/widget/pause_menu_widget.dart';
import 'package:runner_test1/widget/heart_display_widget.dart';
import 'package:runner_test1/widget/gameOver_menu_widget.dart';
import 'package:runner_test1/screens/main_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();
  runApp(
MyApp()
  );

  runApp(
    GameWidget(
      game: JinoGame(),
      overlayBuilderMap: {
        'MainMenu': (context, game) =>
            MainMenu(onPlay: () {
              (game as JinoGame).overlays.remove('MainMenu');
              game.overlays.remove('MainMenu');
              game.overlays.add('HeartDisplay'); // add after play
              game.overlays.add('PauseButton');  // add after play
              game.resumeEngine(); // start the game
            },
            ),

        'PauseButton': (context, game) =>
            PauseButtonWidget(game: game as JinoGame),

        'PauseMenu': (context, game) =>
            PauseMenuWidget(game: game as JinoGame),

        'HeartDisplay': (context, game) =>
            HeartDisplayWidget(currentHealth: (game as JinoGame).health,
            ),

        'GameOverMenu': (context, game) =>
            GameOverMenu(game: (game as JinoGame), score: (game.scoreManager.finalScore),
            ),



      },
      initialActiveOverlays: const ['MainMenu'], // the first overlay that shows
    ),

  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jino Run',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Jino Run')
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final JinoGame game;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    game = JinoGame();

    _loadCharacter();
  }

  Future<void> _loadCharacter() async {
    final mySprite = await Sprite.load('idle.gif');

    var jinoSprite = SpriteComponent(
      sprite: mySprite,
      size: Vector2.all(64),
      position: Vector2(100, 100),
    );

    game.add(jinoSprite);
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).orientation);

    return Scaffold(
      body: GameWidget(game: game),
    );
  }
}
