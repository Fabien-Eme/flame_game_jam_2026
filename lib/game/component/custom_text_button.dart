import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_game_jam_2026/game/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/rendering.dart';

import '../../utils/palette.dart';

class CustomTextButton extends PositionComponent with HasGameReference<FGJ2026>, HoverCallbacks, HasWorldReference<World> {
  CustomTextButton({required String text, required this.onPressed, super.position, super.key}) : _text = text;

  late final ButtonComponent buttonComponent;
  late final TextComponent _label;
  String _text;
  Function(FGJ2026 game, World world) onPressed;

  String get text => _text;
  set text(String value) {
    _text = value;
    if (isLoaded) {
      _label.text = value;
    }
  }

  @override
  void onLoad() {
    add(
      buttonComponent = ButtonComponent(
        anchor: Anchor.center,
        button: _label = TextComponent(
          text: _text,
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
