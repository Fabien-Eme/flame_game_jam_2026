import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/text.dart';
import 'package:flutter/rendering.dart';

import '../../utils/palette.dart';

class WonComponent extends ColumnComponent {
  WonComponent({required super.position, super.key});

  @override
  void onLoad() {
    super.onLoad();
    anchor = Anchor.center;
    crossAxisAlignment = CrossAxisAlignment.center;

    gap = 20;

    add(
      TextComponent(
        text: 'You won! Congratulations...',
        textRenderer: TextPaint(
          style: TextStyle(fontSize: 40, color: Palette.trueBlack, fontWeight: FontWeight.bold),
        ),
      ),
    );
    add(
      TextComponent(
        text: 'Ohhh, by the way: It was never about escaping...',
        textRenderer: TextPaint(
          style: TextStyle(fontSize: 40, color: Palette.trueBlack, fontWeight: FontWeight.bold),
        ),
      ),
    );
    add(
      TextComponent(
        text: 'You just trained the surveillance system....',
        textRenderer: TextPaint(
          style: TextStyle(fontSize: 40, color: Palette.trueBlack, fontWeight: FontWeight.bold),
        ),
      ),
    );
    add(
      TextComponent(
        text: 'Nobody will EVER escape now. Thanks to you!',
        textRenderer: TextPaint(
          style: TextStyle(fontSize: 40, color: Palette.trueBlack, fontWeight: FontWeight.bold),
        ),
      ),
    );

    add(
      TextComponent(
        text: 'Now try the speedrun mode to beat the record!',
        textRenderer: TextPaint(style: TextStyle(fontSize: 30, color: Palette.trueBlack)),
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
        text: 'Press any button to return to the main menu',
        textRenderer: TextPaint(style: TextStyle(fontSize: 30, color: Palette.trueBlack)),
      ),
    );
  }
}
