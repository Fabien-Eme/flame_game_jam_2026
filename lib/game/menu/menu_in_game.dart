import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_game_jam_2026/game/game.dart';
import 'package:flutter/rendering.dart';

import '../../utils/palette.dart';

class MenuInGame extends PositionComponent with HasGameReference<FGJ2026>, HoverCallbacks, TapCallbacks {
  final World world = World();
  late final CameraComponent cameraComponent;

  MenuInGame({required super.position, super.key});

  late final RectangleComponent rectangleComponent;
  late final TextComponent textComponent;

  @override
  void onLoad() {
    super.onLoad();

    add(rectangleComponent = RectangleComponent.fromRect(Rect.fromLTWH(0, 0, 100, 50), paint: Paint()..color = Palette.trueBlack));
    add(
      textComponent = TextComponent(
        position: Vector2(50, 25),
        anchor: Anchor.center,
        text: 'MENU',
        textRenderer: TextPaint(style: TextStyle(fontSize: 30, color: Palette.white)),
      ),
    );
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return rectangleComponent.containsLocalPoint(point);
  }

  @override
  void onHoverEnter() {
    super.onHoverEnter();
    game.mouseCursor = SystemMouseCursors.click;
  }

  @override
  void onHoverExit() {
    super.onHoverExit();
    game.mouseCursor = SystemMouseCursors.basic;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    game.audioController.playMenuClickSound();
    game.router.pushReplacementNamed('mainMenu');
  }
}
