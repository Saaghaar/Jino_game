import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ScoreManager extends TextComponent {
  int _score = 0;

  ScoreManager(Vector2 screenSize)
      : super(
    text: 'Score: 0',
    position: Vector2(screenSize.x / 2, 15),
    anchor: Anchor.topCenter,
    textRenderer: TextPaint(
      style: const TextStyle(
        fontSize: 28,
        color: const Color(0xFF4C041B),
        // fontWeight: FontWeight.bold,
        fontFamily: 'Feast Of Flesh',
      ),
    ),
    priority: 100,
  );

  void increaseScore(int value) {
    _score += value;
    text = 'Score: $_score';
  }

  int get score => _score;

  void reset() {
    _score = 0;
    text = 'Score: 0';
  }
}