import 'package:flutter/material.dart';
import 'package:runner_test1/game/game.dart';
import 'package:flame_audio/flame_audio.dart';

class GameOverMenu extends StatelessWidget {
  final int score;
  final int bestScore;
  final JinoGame game;

  const GameOverMenu({
    super.key,
    required this.score,
    required this.bestScore,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: Color(0x805A0043),
          borderRadius: BorderRadius.circular(16),
        ),
        constraints: const BoxConstraints(maxWidth: 400), // set the max width
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // Game Over text
            const Text(
              'Game Over',
              style: TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontFamily: 'Feast Of Flesh',
              ),
            ),

            // show final score
            const SizedBox(height: 16),
            Text(
              'Score: $score',
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontFamily: 'Feast Of Flesh',
              ),
            ),

            // show best score
            const SizedBox(height: 16),
            Text(
              'Best Score: $bestScore',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontFamily: 'Feast Of Flesh',
              ),
            ),

            const SizedBox(height: 24),

            Row(
                mainAxisAlignment: MainAxisAlignment.center, // put the buttons in center
                children: [
                  // restart button
                  ElevatedButton(
                    onPressed: () {
                      game.overlays.remove('GameOverMenu');
                      FlameAudio.play('select.wav');
                      FlameAudio.bgm.play('bgm.wav'); // restart bg music
                      game.reset();
                    },
                    child: const Text('Restart',
                      style: TextStyle(
                        fontFamily: 'Feast Of Flesh',
                        color: Color(0xFF4C041B),
                        fontSize: 25,
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  // main menu button
                  ElevatedButton(
                    onPressed: () {
                      game.overlays.remove('GameOverMenu');
                      game.reset();
                      game.pauseEngine();
                      FlameAudio.bgm.stop(); // stop bg music
                      FlameAudio.play('select.wav');
                      game.overlays.add('MainMenu');
                    },
                    // restart button style
                    child: const Text('Main Menu',
                      style: TextStyle(
                        fontFamily: 'Feast Of Flesh',
                        color: Color(0xFF4C041B),
                        fontSize: 25,
                      ),
                    ),
                  ),
                ]
            )
          ],
        ),
      ),
    );
  }
}