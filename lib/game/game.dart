import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/palette.dart';
import 'controller/audio_controller.dart';
import 'controller/checkpoint_controller.dart';
import 'controller/keyboard_controller.dart';
import 'controller/keycard_controller.dart';
import 'router/router.dart';
import 'controller/universal_gamepad_controller.dart';
import 'controller/input_controller.dart';

enum GraphicsQuality { normal, high }

class FGJ2026 extends FlameGame with HasKeyboardHandlerComponents {
  static const double gameWidth = 1300;
  static const double gameHeight = 700;

  late final RouterComponent router;

  late final AudioController audioController;
  late final CheckpointController checkpointController;
  late final KeycardController keycardController;
  late final KeyboardController keyboardController;
  late final UniversalGamepadController universalGamepadController;
  late final InputController inputController;

  Vector2 mousePosition = Vector2.zero();

  bool postProcessing = true;
  GraphicsQuality graphicsQuality = kIsWeb ? GraphicsQuality.normal : GraphicsQuality.high;

  double get cameraRayQualityMultiplier => graphicsQuality == GraphicsQuality.high ? 1.0 : 0.55;
  int get minimumCameraRayCount => graphicsQuality == GraphicsQuality.high ? 15 : 8;

  @override
  FutureOr<void> onLoad() async {
    await add(audioController = AudioController());
    await add(checkpointController = CheckpointController());
    await add(keycardController = KeycardController());
    await add(keyboardController = KeyboardController());
    await add(universalGamepadController = UniversalGamepadController());
    await add(inputController = InputController());
    await checkpointController.getCurrentCheckpointInMemory();

    final asyncPrefs = SharedPreferencesAsync();
    graphicsQuality = GraphicsQuality.values.byName(await asyncPrefs.getString('graphicsQuality') ?? GraphicsQuality.high.name);
    postProcessing = await asyncPrefs.getBool('postProcessing') ?? (graphicsQuality == GraphicsQuality.high);

    /// Add router
    add(router = GameRouter());

    if (kDebugMode) add(FpsTextComponent());

    return super.onLoad();
  }

  @override
  Color backgroundColor() {
    return Palette.trueBlack;
  }
}
