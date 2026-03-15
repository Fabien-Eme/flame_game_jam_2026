import 'package:flame/components.dart';
import 'package:flame_game_jam_2026/game/game.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../level/level_world.dart';

class KeyboardController extends Component with HasGameReference<FGJ2026>, KeyboardHandler {
  LevelWorld? levelWorld;

  String button1Keyboard = '';
  String button2Keyboard = '';
  String upKeyboard = '';
  String downKeyboard = '';
  String leftKeyboard = '';
  String rightKeyboard = '';

  Future<void> saveKeyboardConfigurationToPrefs(
    String button1Keyboard,
    String button2Keyboard,
    String upKeyboard,
    String downKeyboard,
    String leftKeyboard,
    String rightKeyboard,
  ) async {
    final asyncPrefs = SharedPreferencesAsync();
    asyncPrefs.setString('button1Keyboard', button1Keyboard);
    asyncPrefs.setString('button2Keyboard', button2Keyboard);
    asyncPrefs.setString('upKeyboard', upKeyboard);
    asyncPrefs.setString('downKeyboard', downKeyboard);
    asyncPrefs.setString('leftKeyboard', leftKeyboard);
    asyncPrefs.setString('rightKeyboard', rightKeyboard);
    asyncPrefs.setBool('isKeyboardCalibrated', true);
    asyncPrefs.setBool('isKeyboardChosen', true);
  }

  void saveSpecificKey(String key, String value) async {
    final asyncPrefs = SharedPreferencesAsync();
    await asyncPrefs.setString(key, value);

    final areAllKeysSet = await checkIfAllKeysAreSet();
    if (areAllKeysSet) {
      asyncPrefs.setBool('isKeyboardCalibrated', true);
      asyncPrefs.setBool('isKeyboardChosen', true);
    }
  }

  Future<bool> checkIfAllKeysAreSet() async {
    final asyncPrefs = SharedPreferencesAsync();

    final button1Keyboard = await asyncPrefs.getString('button1Keyboard');
    final button2Keyboard = await asyncPrefs.getString('button2Keyboard');
    final upKeyboard = await asyncPrefs.getString('upKeyboard');
    final downKeyboard = await asyncPrefs.getString('downKeyboard');
    final leftKeyboard = await asyncPrefs.getString('leftKeyboard');
    final rightKeyboard = await asyncPrefs.getString('rightKeyboard');

    return button1Keyboard != null &&
        button1Keyboard.isNotEmpty &&
        button2Keyboard != null &&
        button2Keyboard.isNotEmpty &&
        upKeyboard != null &&
        upKeyboard.isNotEmpty &&
        downKeyboard != null &&
        downKeyboard.isNotEmpty &&
        leftKeyboard != null &&
        leftKeyboard.isNotEmpty &&
        rightKeyboard != null &&
        rightKeyboard.isNotEmpty;
  }

  Future<bool> checkIfKeyboardIsCalibrated() async {
    final asyncPrefs = SharedPreferencesAsync();
    return await asyncPrefs.getBool('isKeyboardCalibrated') ?? false;
  }

  Future<void> retrieveGamepadConfigurationFromPrefs() async {
    final asyncPrefs = SharedPreferencesAsync();
    button1Keyboard = await asyncPrefs.getString('button1Keyboard') ?? '';
    button2Keyboard = await asyncPrefs.getString('button2Keyboard') ?? '';
    upKeyboard = await asyncPrefs.getString('upKeyboard') ?? '';
    downKeyboard = await asyncPrefs.getString('downKeyboard') ?? '';
    leftKeyboard = await asyncPrefs.getString('leftKeyboard') ?? '';
    rightKeyboard = await asyncPrefs.getString('rightKeyboard') ?? '';
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (levelWorld == null || !levelWorld!.isMounted) return true;

    if (event.logicalKey.keyLabel == button1Keyboard) {
      if (event is KeyDownEvent) {
        game.universalGamepadController.button0Pressed();
      } else if (event is KeyUpEvent) {
        game.universalGamepadController.button0Released();
      }
    } else if (event.logicalKey.keyLabel == button2Keyboard) {
      if (event is KeyDownEvent) {
        game.universalGamepadController.button1Pressed();
      } else if (event is KeyUpEvent) {
        game.universalGamepadController.button1Released();
      }
    } else if (event.logicalKey.keyLabel == upKeyboard) {
      if (event is KeyDownEvent) {
        upPressed();
      } else if (event is KeyUpEvent) {
        upReleased();
      }
    } else if (event.logicalKey.keyLabel == downKeyboard) {
      if (event is KeyDownEvent) {
        downPressed();
      } else if (event is KeyUpEvent) {
        downReleased();
      }
    } else if (event.logicalKey.keyLabel == leftKeyboard) {
      if (event is KeyDownEvent) {
        leftPressed();
      } else if (event is KeyUpEvent) {
        leftReleased();
      }
    } else if (event.logicalKey.keyLabel == rightKeyboard) {
      if (event is KeyDownEvent) {
        rightPressed();
      } else if (event is KeyUpEvent) {
        rightReleased();
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }

  void upPressed() {
    levelWorld?.playerMovementController.direction.y = -1;
  }

  void upReleased() {
    levelWorld?.playerMovementController.direction.y = 0;
  }

  void downPressed() {
    levelWorld?.playerMovementController.direction.y = 1;
  }

  void downReleased() {
    levelWorld?.playerMovementController.direction.y = 0;
  }

  void leftPressed() {
    levelWorld?.playerMovementController.direction.x = -1;
  }

  void leftReleased() {
    levelWorld?.playerMovementController.direction.x = 0;
  }

  void rightPressed() {
    levelWorld?.playerMovementController.direction.x = 1;
  }

  void rightReleased() {
    levelWorld?.playerMovementController.direction.x = 0;
  }
}
