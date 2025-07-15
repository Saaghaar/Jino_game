import 'package:flame/components.dart';

class DifficultyManager extends Component {

  double baseSpeed = 200;         // Initial speed of enemies
  double backgroundSpeed = 20;    // Initial speed of background
  double score = 0;

  DifficultyManager();

  void updateDifficulty(double currentScore) {
    score = currentScore;

    // increasing score == increasing difficulty
    baseSpeed = 200 + (score * 1.5);         //enemies
    backgroundSpeed = 20 + (score * 0.1);    //background

    // Limiting top speed for better control
    baseSpeed = baseSpeed.clamp(200, 500);
    backgroundSpeed = backgroundSpeed.clamp(20, 80);
  }

  double get spawnInterval {
    // Spawn interval, depending on the score, between 1 to 2.5 sec
    return (2.0 - score * 0.015).clamp(1, 2.5);
  }

}
