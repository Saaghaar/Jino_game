import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flame_audio/flame_audio.dart';

import 'package:runner_test1/game/game.dart';

class PauseButtonWidget extends StatelessWidget {
  final JinoGame game;

  const PauseButtonWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
            onTap: () {
              game.pauseEngine();
              FlameAudio.bgm.pause(); // pause bg music
              game.overlays.remove('PauseButton');
              game.overlays.add('PauseMenu');
            },
            child: SvgPicture.asset(
              'assets/icons/pause.svg',
              width: 32,
              height: 32,
              colorFilter: const ColorFilter.mode(
                Color(0xFF4C041B),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
