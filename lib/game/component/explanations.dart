import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/rendering.dart';

import '../../utils/palette.dart';

class Explanations extends PositionComponent {
  Explanations({required super.position, super.key});

  @override
  void onLoad() {
    add(
      ColumnComponent(
        children: [
          TextComponent(
            text: 'Button 1 : Interact',
            textRenderer: TextPaint(style: TextStyle(fontSize: 20, color: Palette.white)),
          ),
          TextComponent(
            text: 'Button 2 : Run',
            textRenderer: TextPaint(style: TextStyle(fontSize: 20, color: Palette.white)),
          ),
          TextComponent(
            text: 'Analog stick : Move',
            textRenderer: TextPaint(style: TextStyle(fontSize: 20, color: Palette.white)),
          ),
        ],
      ),
    );

    super.onLoad();
  }
}
