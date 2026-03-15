import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_game_jam_2026/game/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/rendering.dart';

import '../../utils/palette.dart';

class CustomTextButton extends PositionComponent with HasGameReference<FGJ2026>, HoverCallbacks, HasWorldReference<World> {
  CustomTextButton({required this.text, required this.onPressed, super.position, super.key});

  late final ButtonComponent buttonComponent;
  String text;
  Function(FGJ2026 game, World world) onPressed;

  @override
  void onLoad() {
    add(
      buttonComponent = ButtonComponent(
        anchor: Anchor.center,
        button: TextComponent(
          text: text,
          textRenderer: TextPaint(style: TextStyle(fontSize: 30, color: Palette.white)),
        ),
        onPressed: () {
          game.audioController.playMenuClickSound();
          onPressed(game, world);
        },
      ),
    );

    super.onLoad();
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return buttonComponent.containsLocalPoint(point + buttonComponent.size / 2);
  }

  @override
  void onHoverEnter() {
    game.mouseCursor = SystemMouseCursors.click;
    super.onHoverEnter();
  }

  @override
  void onHoverExit() {
    game.mouseCursor = SystemMouseCursors.basic;
    super.onHoverExit();
  }
}
