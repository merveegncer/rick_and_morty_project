import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class GreenText extends StatelessWidget {
  final text;
  final size;
  const GreenText({super.key, this.text, this.size});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AutoSizeText(text,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
                shadows: const [
                  Shadow(
                      blurRadius: 7,
                      color: Color.fromARGB(255, 208, 217, 75),
                      offset: Offset(-4, -4)),
                  Shadow(
                      color: Color.fromARGB(166, 21, 7, 104),
                      blurRadius: 20,
                      offset: Offset(8, 10)),
                  Shadow(
                      color: Color.fromARGB(153, 11, 3, 54),
                      blurRadius: 20,
                      offset: Offset(8, 10)),
                  Shadow(
                      color: Color.fromARGB(255, 29, 103, 34),
                      blurRadius: 17,
                      offset: Offset(5, 5))
                ],
                fontFamily: 'Rick',
                fontSize: size,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 8
                  ..color = Color.fromARGB(255, 170, 217, 75).withOpacity(1))),
        AutoSizeText(text,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
                shadows: const [
                  Shadow(
                      blurRadius: 10,
                      color: Color.fromARGB(255, 208, 217, 75),
                      offset: Offset(-3, 5)),
                  Shadow(
                      color: Color.fromARGB(255, 29, 103, 34),
                      blurRadius: 7,
                      offset: Offset(3, 5)),
                ],
                fontFamily: 'Rick',
                fontSize: size,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 6
                  ..color = Color.fromARGB(255, 174, 217, 75))),
        AutoSizeText(text,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(
              shadows: const [
                Shadow(
                    blurRadius: 5,
                    color: Color.fromARGB(255, 68, 72, 17),
                    offset: Offset(-1, -1)),
              ],
              fontFamily: 'Rick',
              fontSize: size,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3
                ..color = const Color.fromARGB(255, 8, 64, 74),
            )),
        AutoSizeText(
          text,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(
              shadows: const [
                Shadow(
                    blurRadius: 5,
                    color: Color.fromARGB(255, 14, 107, 123),
                    offset: Offset(-2, -2)),
              ],
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 5, 175, 197),
              fontSize: size,
              fontFamily: 'Rick'),
        )
      ],
    );
  }
}
