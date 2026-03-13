import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/rendering.dart';

import '../../utils/palette.dart';

class Explanations extends PositionComponent {
  Explanations({required super.position, required this.inGame, super.key});

  final bool inGame;

  @override
  void onLoad() {
    if (inGame) {
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
    } else {
      add(
        RectangleComponent(
          anchor: Anchor.centerLeft,
          position: Vector2(-20, 0),
          size: Vector2(300, 250),
          paint: Paint()
            ..strokeWidth = 3
            ..style = PaintingStyle.stroke
            ..color = Palette.white,
        ),
      );
      add(
        ColumnComponent(
          anchor: Anchor.centerLeft,
          gap: 10,
          children: [
            TextComponent(
              text: 'Collect key cards.',
              textRenderer: TextPaint(style: TextStyle(fontSize: 25, color: Palette.white)),
            ),
            TextComponent(
              text: 'Unlock matching doors.',
              textRenderer: TextPaint(style: TextStyle(fontSize: 25, color: Palette.white)),
            ),
            TextComponent(
              text: 'Reach checkpoints.',
              textRenderer: TextPaint(style: TextStyle(fontSize: 25, color: Palette.white)),
            ),
            TextComponent(
              text: 'Avoid cameras.',
              textRenderer: TextPaint(style: TextStyle(fontSize: 25, color: Palette.white)),
            ),
            TextComponent(
              text: 'Follow the arrows.',
              textRenderer: TextPaint(style: TextStyle(fontSize: 25, color: Palette.white)),
            ),
          ],
        ),
      );
    }
    super.onLoad();
  }
}
