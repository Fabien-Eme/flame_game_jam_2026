import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/text.dart';
import 'package:flutter/rendering.dart';

import '../../utils/palette.dart';

class WelcomeComponent extends ColumnComponent {
  WelcomeComponent({required super.position, super.key});

  @override
  void onLoad() {
    super.onLoad();
    anchor = Anchor.center;
    crossAxisAlignment = CrossAxisAlignment.center;

    gap = 20;

    add(
      TextComponent(
        text: "Psst... Can you hear me? Stay out of the cameras' sight.",
        textRenderer: TextPaint(
          style: TextStyle(fontSize: 40, color: Palette.trueBlack, fontWeight: FontWeight.bold),
        ),
      ),
    );
    add(
      TextComponent(
        text: "The path is clear. We're getting you out of this sector.",
        textRenderer: TextPaint(
          style: TextStyle(fontSize: 40, color: Palette.trueBlack, fontWeight: FontWeight.bold),
        ),
      ),
    );
    add(
      TextComponent(
        text: "This is your one and only chance to escape.",
        textRenderer: TextPaint(
          style: TextStyle(fontSize: 40, color: Palette.trueBlack, fontWeight: FontWeight.bold),
        ),
      ),
    );
    add(
      TextComponent(
        text: "Run, #FGJ2026! Break the cycle! Don't let them win!",
        textRenderer: TextPaint(
          style: TextStyle(fontSize: 40, color: Palette.trueBlack, fontWeight: FontWeight.bold),
        ),
      ),
    );
    add(
      TextComponent(
        text: '',
        textRenderer: TextPaint(style: TextStyle(fontSize: 30, color: Palette.trueBlack)),
      ),
    );
    add(
      TextComponent(
        text: 'Press any button to initiate the breach',
        textRenderer: TextPaint(style: TextStyle(fontSize: 30, color: Palette.trueBlack)),
      ),
    );
  }
}
