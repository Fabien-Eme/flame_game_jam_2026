import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_game_jam_2026/game/game.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/palette.dart';
import 'dart:async';

class ButtonChooseKey extends PositionComponent with HasGameReference<FGJ2026>, KeyboardHandler {
  ButtonChooseKey({required this.keyIdentifier, super.key});

  late ButtonComponent buttonComponent;
  final String keyIdentifier;

  bool isChoosingKey = false;

  @override
  FutureOr<void> onLoad() async {
    final asyncPrefs = SharedPreferencesAsync();
    final key = await asyncPrefs.getString(keyIdentifier);

    buttonComponent = ButtonComponent(
      anchor: Anchor.center,
      button: TextComponent(
        text: key ?? '<CHOOSE KEY>',
        textRenderer: TextPaint(
          style: TextStyle(fontSize: 40, color: Palette.white, fontWeight: FontWeight.bold),
        ),
      ),
      onPressed: () {
        buttonComponent.removeFromParent();
        isChoosingKey = true;
      },
    );

    add(buttonComponent);

    size = buttonComponent.size;
    return super.onLoad();
  }

  void chooseKey() {}

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (isChoosingKey) {
      if (event is KeyDownEvent) {
        isChoosingKey = false;
        game.keyboardController.saveSpecificKey(keyIdentifier, event.logicalKey.keyLabel);
        buttonComponent = ButtonComponent(
          anchor: Anchor.center,
          button: TextComponent(
            text: (event.logicalKey.keyLabel == " " ? "SPACE" : event.logicalKey.keyLabel),
            textRenderer: TextPaint(
              style: TextStyle(fontSize: 40, color: Palette.white, fontWeight: FontWeight.bold),
            ),
          ),
          onPressed: () {
            buttonComponent.removeFromParent();
            isChoosingKey = true;
          },
        );
        add(buttonComponent);
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }
}
