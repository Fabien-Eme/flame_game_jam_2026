import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_game_jam_2026/game/menu/main_menu.dart';
import 'package:flutter/rendering.dart';

import '../../utils/palette.dart';
import '../game.dart';
import 'dart:async';

class MenuEntry extends PositionComponent with HasGameReference<FGJ2026>, HoverCallbacks, HasWorldReference<World>, TapCallbacks {
  MenuEntry({required this.text, this.isSelected = false, this.isAvailable = true, super.key});

  final String text;

  late final TextComponent textComponent;

  bool isSelected = false;
  bool isAvailable;

  RectangleComponent leftSelection = RectangleComponent();
  RectangleComponent rightSelection = RectangleComponent();

  @override
  FutureOr<void> onLoad() async {
    await add(
      textComponent = TextComponent(
        anchor: Anchor.center,
        text: text,
        textRenderer: TextPaint(style: TextStyle(fontSize: 30, color: isAvailable ? Palette.white : Palette.grey)),
      ),
    );

    textComponent.add(RectangleHitbox.relative(Vector2(1.025, 0.7), parentSize: textComponent.size, collisionType: CollisionType.passive));
    return super.onLoad();
  }

  void select() {
    if (!isAvailable || isSelected) return;
    isSelected = true;
    add(
      leftSelection = RectangleComponent(
        anchor: Anchor.center,
        position: Vector2(-25 - textComponent.size.x / 2, 2),
        size: Vector2(25, 5),
        paint: Paint()..color = Palette.white,
      ),
    );
    add(
      rightSelection = RectangleComponent(
        anchor: Anchor.center,
        position: Vector2(25 + textComponent.size.x / 2, 2),
        size: Vector2(25, 5),
        paint: Paint()..color = Palette.white,
      ),
    );
  }

  void deselect() {
    isSelected = false;
    leftSelection.removeFromParent();
    rightSelection.removeFromParent();
  }

  void toggleSelection() {
    if (isSelected) {
      deselect();
    } else {
      select();
    }
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return textComponent.containsLocalPoint(point + textComponent.size / 2);
  }

  @override
  void onHoverEnter() {
    if (!isAvailable) return;
    (world.parent! as MainMenu).select(this);
    game.mouseCursor = SystemMouseCursors.click;
    super.onHoverEnter();
  }

  @override
  void onHoverExit() {
    game.mouseCursor = SystemMouseCursors.basic;
    super.onHoverExit();
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (!isAvailable) return;
    game.audioController.playMenuClickSound();
    if (text == 'CONTINUE') {
      game.router.pushReplacementNamed('level');
    } else if (text == 'NEW GAME') {
      game.router.pushReplacementNamed('newGame');
    } else if (text == 'SPEED RUN MODE') {
      game.router.pushReplacementNamed('speedRunMode');
    } else if (text == 'INPUT CONFIGURATION') {
      game.router.pushReplacementNamed('gamepadConfiguration');
    } else if (text == 'SETTINGS') {
      game.router.pushReplacementNamed('settings');
    }
    super.onTapDown(event);
  }
}
