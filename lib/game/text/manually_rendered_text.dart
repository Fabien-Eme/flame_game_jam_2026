import 'dart:ui';

import 'package:flame/components.dart';

class ManuallyRenderedText extends TextComponent {
  ManuallyRenderedText({required super.text, required super.anchor, required super.position, required super.textRenderer});

  @override
  void render(Canvas canvas) {}

  void manualRender(Canvas canvas) {
    textRenderer.render(canvas, text, position, anchor: anchor);
  }
}
