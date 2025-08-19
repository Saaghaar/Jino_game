import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';

class MainMenu extends StatelessWidget {
  final VoidCallback onPlay;

  const MainMenu({Key? key, required this.onPlay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
          // set background
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/parallax/main_menu.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        Center(
          child: Container(
            width: 300,
            height: 250,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0x5C5A0043),
              borderRadius: BorderRadius.circular(16),
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Jino Run text
                const Text(
                  'Jino Run',
                  style: TextStyle(
                    fontSize: 45,
                    fontFamily: 'Feast Of Flesh',
                    color: Color(0xFFFFFFFF),
                  ),
                ),

                // Play button
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    FlameAudio.play('select.wav');
                    onPlay();
                },
                  child: const Text('Play',
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
        ),
      ]
    );
  }
}