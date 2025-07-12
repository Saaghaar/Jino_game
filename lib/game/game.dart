import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/parallax.dart';
import 'package:flame/game.dart';
import 'package:runner_test1/game/jino.dart';
import 'package:flame/input.dart';
import 'dart:math'; // for random func
import 'package:runner_test1/game/enemy.dart';
import 'package:flutter/material.dart'; // for colors


class JinoGame extends FlameGame with PanDetector{
  late Jino _jino;

  // variables for creating enemy
  double spawnTimer = 0;
  final Random random = Random();

  // variables for scoring
  int score = 0;
  late TimerComponent scoreTimer;
  late TextComponent scoreText;

  // Creating enemy func
  void spawnEnemyWithRandomDelay() {
    // random time 1 to 3 sec
    final randomDelay = 1.0 + random.nextDouble() * 2.0;

    add(
      TimerComponent(
        period: randomDelay,
        repeat: false,
        removeOnFinish: true,
        onTick: () {
          final type = 1 + random.nextInt(3);
          add(Enemy(type));

          // create new timer
          spawnEnemyWithRandomDelay();
        },
      ),
    );
  }


  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // add enemy
    spawnEnemyWithRandomDelay();

    // Create background
    final parallax = await loadParallaxComponent(
    [
      ParallaxImageData('parallax/layer_sky.png'),
      ParallaxImageData('parallax/layer_cake.png'),
      ParallaxImageData('parallax/layer_clouds.png'),
      ParallaxImageData('parallax/layer_rocks.png'),
      ParallaxImageData('parallax/layer_trees.png'),
      ParallaxImageData('parallax/layer_ground.png'),
    ],
      baseVelocity: Vector2(20, 0), // movement speed
      velocityMultiplierDelta: Vector2(1.5, 1.0), // layer's different speed
    );

    // add scoring timer
    scoreTimer = TimerComponent(
      period: 1,
      repeat: true,
      onTick: () {
        score += 1;
        print("Score: $score");
      },
    );
    add(scoreTimer);

    // add scoring text
    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(size.x/2, 20),
      anchor: Anchor.topCenter,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    add(parallax);

    add(scoreText);
    _jino = Jino();
    add(_jino);
  }

  // set jumping movement (when user swipes up)
  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (info.delta.global.y < -10) {
      _jino.jump();
    }
  }

  @override
  void update(double dt){
    super.update(dt);
    // show score on screen
    scoreText.text = '$score';
  }

}