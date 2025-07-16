import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/parallax.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'dart:math'; // for random func

import 'package:runner_test1/game/jino.dart';
import 'package:runner_test1/game/enemy.dart';
import 'package:runner_test1/game/score_manager.dart';
import 'package:runner_test1/game/difficulty_manager.dart';

class JinoGame extends FlameGame with HasCollisionDetection, PanDetector{
  late Jino _jino;

  // variables for creating enemy
  double spawnTimer = 0;
  final Random random = Random();
  double spawnInterval = 2.0; // start spawn enemies by 2 sec
  double timeSinceLastSpawn = 0;

  // variables for scoring
  int score = 0;
  late ScoreManager scoreManager;
  double timeSinceLastScore = 0;

  // variables for manage difficulty
  late DifficultyManager difficultyManager;

  // variables for speeding
  late final ParallaxComponent _parallax;

  // Creating enemy func
  void spawnEnemyWithRandomDelay() {
    // Base time depending on game difficulty
    final baseDelay = difficultyManager.spawnInterval;

    // Add some randomness to spawn times (e.g. ±0.5 seconds)
    final randomVariation = (random.nextDouble() * 1.0) - 0.5; // Between -0.5 and +0.5
    // Final calculation between enemy spawns with a limited amount of randomness to control game difficulty
    final finalDelay = (baseDelay + randomVariation).clamp(0.8, 3.0);

    add(
      TimerComponent(
        period: finalDelay,
        repeat: false,
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
    difficultyManager = DifficultyManager();

    await super.onLoad();

    // add enemy
    spawnEnemyWithRandomDelay();

    // Create background
    _parallax = await loadParallaxComponent(
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

    add(_parallax);

    // adding score to the game
    scoreManager = ScoreManager(size);
    add(scoreManager);

    _jino = Jino();
    add(_jino);

    // adding difficulty
    difficultyManager = DifficultyManager();
    add(difficultyManager);

    // add pause button
    overlays.add('PauseButton');
  }

  // set jumping movement (when user swipes up)
  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (info.delta.global.y < -5) {
      _jino.jump();
    }
  }

  @override
  void update(double dt){
    super.update(dt);

    // calculate sprayed time
    timeSinceLastScore += dt;

    // 1 sec == +1 score
    if (timeSinceLastScore >= 1.0) {
      scoreManager.increaseScore(1); //Add 1 point every second
      timeSinceLastScore = 0;
    }

    // update game difficulty
    difficultyManager.updateDifficulty(scoreManager.score.toDouble());

    // Speed values are taken from difficultyManager
    final baseSpeed = difficultyManager.baseSpeed;
    final backgroundSpeed = difficultyManager.backgroundSpeed;

    // Apply background speed
    _parallax.parallax?.baseVelocity = Vector2(backgroundSpeed, 0);
  }

  void reset() {
    // Remove all game components(such as enemies and points)
    removeAll(children.toList());

    // reset score
    scoreManager = ScoreManager(size);
    add(scoreManager);

    // reset speed values
    difficultyManager.reset();

    // add background again
    add(_parallax);

    _jino = Jino();
    add(_jino);

    spawnEnemyWithRandomDelay();

    resumeEngine();
  }

}
