import 'dart:ui';

import 'package:flame/text.dart';

import '../../utils/palette.dart';

class MyTextStyle {
  static TextPaint titleWhite = TextPaint(style: const TextStyle(fontSize: 36, color: Palette.white, fontWeight: FontWeight.bold));
  static TextPaint titleBlack = TextPaint(style: const TextStyle(fontSize: 36, color: Palette.black, fontWeight: FontWeight.bold));

  static TextPaint headerWhite = TextPaint(style: const TextStyle(fontSize: 22, color: Palette.white, fontWeight: FontWeight.bold));
  static TextPaint headerDarkGrey = TextPaint(style: const TextStyle(fontSize: 22, color: Palette.darkGrey, fontWeight: FontWeight.bold));
  static TextPaint headerBlack = TextPaint(style: const TextStyle(fontSize: 22, color: Palette.black, fontWeight: FontWeight.bold));

  static TextPaint textWhite = TextPaint(style: const TextStyle(fontSize: 20, color: Palette.white, fontWeight: FontWeight.bold));
  static TextPaint textDarkGrey = TextPaint(style: const TextStyle(fontSize: 20, color: Palette.darkGrey, fontWeight: FontWeight.bold));
  static TextPaint textBlack = TextPaint(style: const TextStyle(fontSize: 20, color: Palette.black, fontWeight: FontWeight.bold));

  static TextPaint buttonTextWhite = TextPaint(style: const TextStyle(fontSize: 14, color: Palette.white, fontWeight: FontWeight.bold));
  static TextPaint buttonTextDarkGrey = TextPaint(style: const TextStyle(fontSize: 14, color: Palette.darkGrey, fontWeight: FontWeight.bold));

  static TextPaint smallTextWhite = TextPaint(style: const TextStyle(fontSize: 14, color: Palette.white, fontWeight: FontWeight.bold));
  static TextPaint smallTextGrey = TextPaint(style: const TextStyle(fontSize: 14, color: Palette.grey, fontWeight: FontWeight.bold));
  static TextPaint smallTextBlack = TextPaint(style: const TextStyle(fontSize: 14, color: Palette.black, fontWeight: FontWeight.bold));

  static TextPaint titleStrokeBlack = TextPaint(
    style: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      foreground:
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0
            ..color = Palette.black,
    ),
  );

  static TextPaint headerStrokeBlack = TextPaint(
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      foreground:
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0
            ..color = Palette.black,
    ),
  );

  static TextPaint textStrokeBlack = TextPaint(
    style: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      foreground:
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0
            ..color = Palette.black,
    ),
  );

  static TextPaint smallTextStrokeBlack = TextPaint(
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      foreground:
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0
            ..color = Palette.black,
    ),
  );
}
