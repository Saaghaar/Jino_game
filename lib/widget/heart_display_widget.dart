import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HeartDisplayWidget extends StatelessWidget {
  final int currentHealth; // number of remain hearts

  const HeartDisplayWidget({super.key, required this.currentHealth});

  @override
  Widget build(BuildContext context) {
    List<Widget> hearts = [];

    for (int i = 0; i < 3; i++) {
      hearts.add(
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: SvgPicture.asset(
            i < currentHealth
                ? 'assets/icons/heart_full.svg'
                : 'assets/icons/heart_broken.svg',
            width: 32,
            height: 32,
            colorFilter: ColorFilter.mode(
              i < currentHealth ? Color(0xFFAA0000) : Color(0xFF4A4A4A), // قرمز یا خاکستری
              BlendMode.srcIn,)
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: hearts,
        ),
      ),
    );
  }
}