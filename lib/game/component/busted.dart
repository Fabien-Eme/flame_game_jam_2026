import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/text.dart';
import 'package:flutter/rendering.dart';

import '../../utils/palette.dart';

class BustedComponent extends ColumnComponent {
  BustedComponent({required super.position, super.key});

  @override
  void onLoad() {
    super.onLoad();
    anchor = Anchor.center;
    crossAxisAlignment = CrossAxisAlignment.center;

    gap = 20;

    add(
      TextComponent(
        text: 'Big Brother caught you!',
        textRenderer: TextPaint(
          style: TextStyle(fontSize: 40, color: Palette.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
    add(
      TextComponent(
        text: 'Press any button to try again',
        textRenderer: TextPaint(style: TextStyle(fontSize: 30, color: Palette.white)),
      ),
    );
  }
}
