import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_game_jam_2026/game/menu/main_menu.dart';
import 'package:flutter/rendering.dart';

import '../../utils/palette.dart';
import '../game.dart';

class MenuEntry extends PositionComponent with HasGameReference<FGJ2026>, HoverCallbacks, HasWorldReference<World>, TapCallbacks {
  MenuEntry({required this.text, this.isSelected = false, super.key});

  final String text;

  late final TextComponent textComponent;

  bool isSelected = false;

  @override
  void onLoad() {
    add(
      textComponent = TextComponent(
        anchor: Anchor.center,
        text: text,
        textRenderer: TextPaint(style: TextStyle(fontSize: 30, color: Palette.white)),
      ),
    );

    textComponent.add(RectangleHitbox.relative(Vector2(1.025, 0.7), parentSize: textComponent.size, collisionType: CollisionType.passive));
    super.onLoad();
  }

  void select() {
    isSelected = true;
  }

  void deselect() {
    isSelected = false;
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
    (world.parent! as MainMenu).select(this);
    game.mouseCursor = SystemMouseCursors.click;
    super.onHoverEnter();
  }

  @override
  void onHoverExit() {
    (world.parent! as MainMenu).deselect(this);
    game.mouseCursor = SystemMouseCursors.basic;
    super.onHoverExit();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.audioController.playMenuClickSound();
    if (text == 'CONTINUE') {
      game.router.pushReplacementNamed('level');
    } else if (text == 'NEW GAME') {
      game.router.pushReplacementNamed('newGame');
    } else if (text == 'SPEED RUN MODE') {
      game.router.pushReplacementNamed('speedRunMode');
    } else if (text == 'GAMEPAD CONFIGURATION') {
      game.router.pushReplacementNamed('gamepadConfiguration');
    } else if (text == 'SETTINGS') {
      game.router.pushReplacementNamed('settings');
    }
    super.onTapDown(event);
  }
}
