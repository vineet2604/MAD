import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScoreBoard extends StatelessWidget {
  final int score;
  final int highScore;
  const ScoreBoard({super.key, required this.highScore, required this.score});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              myTextWidget("SCORE"),
              myTextWidget("$score"),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              myTextWidget("HIGH SCORE"),
              myTextWidget("$highScore"),
            ],
          ),
        ),
      ],
    );
  }
}

Widget myTextWidget(String text) {
  return Text(
    text,
    style: GoogleFonts.fuzzyBubbles(
      fontWeight: FontWeight.w900,
      fontSize: 20,
    ),
  );
}
