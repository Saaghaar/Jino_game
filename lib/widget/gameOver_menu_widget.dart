import 'package:flutter/material.dart';
import 'package:runner_test1/game/game.dart';

class GameOverMenu extends StatelessWidget {
  final int score;
  final JinoGame game;

  const GameOverMenu({
    super.key,
    required this.score,
    required this.game
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.fromLTRB(50, 24, 50, 24),
        decoration: BoxDecoration(
          color: Color(0x805A0043),
          borderRadius: BorderRadius.circular(16),
        ),
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

            // restart button
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                game.overlays.remove('GameOverMenu');
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
          ],
        ),
      ),
    );
  }
}