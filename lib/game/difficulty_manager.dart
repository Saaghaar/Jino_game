import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';

class DifficultyManager extends Component {

  double baseSpeed = 200;         // Initial speed of enemies
  double backgroundSpeed = 20;    // Initial speed of background
  double score = 0;

  double musicRate = 1.0;
  double lastScoreCheckpoint = 0;

  // enemy's animation speed based on score (100 score == +1 speed animation)
  double get speedFactor => (1.0 + (score / 100)).clamp(1.0, 2.5);

  // DifficultyManager();

  void updateDifficulty(double currentScore) {
    score = currentScore;

    // increasing score == increasing difficulty
    baseSpeed = 200 + (score * 1.5);         //enemies
    backgroundSpeed = 20 + (score * 0.1);    //background

    // Limiting top speed for better control
    baseSpeed = baseSpeed.clamp(200, 500);
    backgroundSpeed = backgroundSpeed.clamp(20, 80);

    // increase bg music each 100 point
    if (score - lastScoreCheckpoint >= 100) {
        lastScoreCheckpoint = score;
        increaseMusicSpeed();
    }
  }

  // increasing bg music speed
  void increaseMusicSpeed() {
    if (musicRate < 1.6) {
      musicRate += 0.05;
      final bgmPlayer = FlameAudio.bgm.audioPlayer;
      bgmPlayer.setPlaybackRate(musicRate);
    }
  }

  double get spawnInterval {
    // Spawn interval, depending on the score, between 1 to 2.5 sec
    return (2.0 - score * 0.015).clamp(1, 2.5);
  }

  void reset(){
    baseSpeed = 200;
    backgroundSpeed = 20;
    score = 0;
    lastScoreCheckpoint = 0;
    musicRate = 1.0;

    // restart bg music speed
    final bgmPlayer = FlameAudio.bgm.audioPlayer;
    bgmPlayer.setPlaybackRate(musicRate);
  }

}
