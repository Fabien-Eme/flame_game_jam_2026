import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_game_jam_2026/game/game.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum InputType { keyboard, gamepad }

class InputController extends Component with HasGameReference<FGJ2026> {
  InputController({super.key});

  bool isGamepadCalibrated = false;
  bool isKeyboardCalibrated = false;

  bool isGamepadChosen = true;

  @override
  FutureOr<void> onLoad() async {
    final asyncPrefs = SharedPreferencesAsync();
    isGamepadCalibrated = await asyncPrefs.getBool('isGamepadCalibrated') ?? false;
    isKeyboardCalibrated = await asyncPrefs.getBool('isKeyboardCalibrated') ?? false;
    isGamepadChosen = await asyncPrefs.getBool('isGamepadChosen') ?? true;

    if (isGamepadCalibrated) {
      await game.universalGamepadController.retrieveGamepadConfigurationFromPrefs();
    }
    if (isKeyboardCalibrated) {
      await game.keyboardController.retrieveGamepadConfigurationFromPrefs();
    }
    super.onLoad();
  }
}
