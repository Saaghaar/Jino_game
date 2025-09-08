import 'package:flutter/material.dart';
import 'package:runner_test1/game/game.dart';
import 'package:flame_audio/flame_audio.dart';

class PauseMenuWidget extends StatelessWidget {
  final JinoGame game;

  const PauseMenuWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0x805A0043),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // pause menu text
            const Text(
              'Game Paused',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontFamily: 'Feast Of Flesh',
              ),
            ),

            // resume button
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                game.overlays.remove('PauseMenu');
                game.overlays.add('PauseButton');
                FlameAudio.play('select.wav');
                FlameAudio.bgm.resume(); // replay bg music
                game.resumeEngine();
              },
              // resume button style
              child: const Text('Resume',
                style: TextStyle(
                    fontFamily: 'Feast Of Flesh',
                    color: Color(0xFF4C041B),
                    fontSize: 25,
                ),
              ),
            ),

            // restart button
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                game.overlays.remove('PauseMenu');
                game.overlays.add('PauseButton');
                game.reset();
                FlameAudio.play('select.wav');
                FlameAudio.bgm.play('bgm.wav'); // restart bg music
              },
              // restart button style
              child: const Text('Restart',
                style: TextStyle(
                    fontFamily: 'Feast Of Flesh',
                    color: Color(0xFF4C041B),
                    fontSize: 25,
                ),
              ),
            ),

            // main menu button
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                game.overlays.remove('PauseMenu');
                game.reset();
                game.pauseEngine();
                FlameAudio.bgm.stop(); // stop bg music
                FlameAudio.play('select.wav');
                game.overlays.add('MainMenu');
              },
              // main menu button style
              child: const Text('Main Menu',
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