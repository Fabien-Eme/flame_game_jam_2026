import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

import '../../utils/palette.dart';
import '../text/manually_rendered_text.dart';
import 'snackbar_controller.dart';

class Snackbar extends PositionComponent {
  String text;

  Snackbar({required this.text});

  late final ManuallyRenderedText textComponent;
  double opacity = 1;
  double timePassed = 0;

  @override
  void onLoad() {
    super.onLoad();
    anchor = Anchor.center;
    position = Vector2(0, -600);

    textComponent = ManuallyRenderedText(
      text: text,
      anchor: Anchor.center,
      position: position,
      textRenderer: TextPaint(style: const TextStyle(fontSize: 22, color: Palette.white, fontWeight: FontWeight.bold)),
    );
  }

  void manualRender(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(position.x - textComponent.size.x / 2 * 1.05, position.y - textComponent.size.y / 2, textComponent.size.x * 1.05, textComponent.size.y * 1.1),
        const Radius.circular(10),
      ),
      Paint()..color = Palette.blackAlmostOpaque.withValues(alpha: opacity),
    );

    textComponent.position = position;
    textComponent.textRenderer = TextPaint(style: TextStyle(fontSize: 22, color: Color.fromRGBO(255, 255, 255, opacity), fontWeight: FontWeight.bold));
    textComponent.manualRender(canvas);
  }

  @override
  void update(double dt) {
    if (position.y < -250) {
      position.y += 3000 * clampDouble((-position.y - 250) / 250, 0.05, 1) * dt;
      if (position.y > -250) {
        position.y = -250;
      }
    }

    if (position.y == -250) {
      timePassed += dt;
    }

    if (opacity != 0 && timePassed > 1.5) {
      if (position.y == -250) {
        opacity -= 1 * dt;
        if (opacity < 0) {
          opacity = 0;
        }
      }
    }

    if (opacity == 0) {
      (parent as SnackbarController).removeSnackbar(this);
    }
    super.update(dt);
  }
}
