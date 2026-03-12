import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import '../level/level_world.dart';
import '../../utils/palette.dart';

class KeyCardHUD extends PositionComponent with HasWorldReference<LevelWorld> {
  KeyCardHUD({required super.position, super.key});

  List<Color> keyCards = [];

  @override
  void onLoad() {
    priority = 999;

    add(RectangleComponent(position: Vector2.zero(), size: Vector2(125, 100), paint: Paint()..color = Palette.whiteVeryTransparent));

    add(
      TextComponent(
        anchor: Anchor.center,
        position: Vector2(62.5, 20),
        text: 'Key Cards',
        textRenderer: TextPaint(style: TextStyle(fontSize: 20, color: Palette.white)),
      ),
    );
    super.onLoad();
  }

  void addKeyCard(Color color) {
    keyCards.add(color);
    add(
      RectangleComponent(
        anchor: Anchor.center,
        position: Vector2(keyCards.length * 20 + 10, 60),
        size: Vector2(10, 20),
        paint: Paint()..color = color,
      ),
    );
  }

  void resetKeyCards() async {
    for (var child in children) {
      child.removeFromParent();
    }
    keyCards.clear();
  }
}
