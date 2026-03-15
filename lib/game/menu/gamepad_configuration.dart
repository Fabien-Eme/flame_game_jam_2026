import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_game_jam_2026/game/game.dart';
import 'package:flame_game_jam_2026/game/level/post_process.dart';
import 'package:flutter/rendering.dart';
import 'package:gamepads/gamepads.dart';

import '../component/back_button.dart';
import '../component/custom_text_button.dart';
import '../component/loading_bar.dart';
import '../../utils/palette.dart';
import 'package:flame/experimental.dart';

import 'button_choose_key.dart';

enum CalibrationPhase { choose, welcome, rest, topAndBottom, rightAndLeft, button1, button2, finish, keyboard }

class GamepadConfiguration extends PositionComponent with HasGameReference<FGJ2026> {
  final World world = World();
  late final CameraComponent cameraComponent;

  bool isGamepadChosen = true;

  CalibrationPhase calibrationPhase = CalibrationPhase.choose;

  late final TextComponent welcomeTextComponent;
  late final TextComponent stepTextComponent;

  double xRest = 0;
  double yRest = 0;

  double xMin = 0;
  double xMax = 0;
  double yMin = 0;
  double yMax = 0;

  String button1Key = '';
  String button2Key = '';

  @override
  FutureOr<void> onLoad() async {
    await add(world);

    await add(cameraComponent = CameraComponent.withFixedResolution(width: FGJ2026.gameWidth, height: FGJ2026.gameHeight, world: world));
    cameraComponent.viewfinder.anchor = Anchor.topLeft;
    cameraComponent.postProcess = game.postProcessing ? CRTPostProcess() : null;

    await world.add(
      RectangleComponent.fromRect(Rect.fromLTWH(0, 0, FGJ2026.gameWidth, FGJ2026.gameHeight), paint: Paint()..color = Palette.veryDarkGrey),
    );

    await world.add(BackButton(text: 'Main Menu', position: Vector2(FGJ2026.gameWidth - 100, FGJ2026.gameHeight - 75)));

    await world.add(
      stepTextComponent = TextComponent(
        anchor: Anchor.center,
        position: Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight - 50),
        text: '',
        textRenderer: TextPaint(style: TextStyle(fontSize: 30, color: Palette.white)),
      ),
    );

    callCalibrationPhase();

    return super.onLoad();
  }

  void callCalibrationPhase() {
    switch (calibrationPhase) {
      case CalibrationPhase.choose:
        addChooseComponent();
        break;
      case CalibrationPhase.welcome:
        addWelcomeComponent();
        stepTextComponent.text = 'Step 1/6';
        break;
      case CalibrationPhase.rest:
        addListenComponent();
        stepTextComponent.text = 'Step 2/6';
        break;
      case CalibrationPhase.topAndBottom:
        stepTextComponent.text = 'Step 3/6';
        break;
      case CalibrationPhase.rightAndLeft:
        stepTextComponent.text = 'Step 4/6';
        break;
      case CalibrationPhase.button1:
        stepTextComponent.text = 'Step 5/6';
        break;
      case CalibrationPhase.button2:
        stepTextComponent.text = 'Step 6/6';
        break;
      case CalibrationPhase.finish:
        stepTextComponent.text = '';
        saveGamepadConfigurationToPrefs();
        break;
      case CalibrationPhase.keyboard:
        addKeyboardComponent();
        break;
    }
  }

  ///
  ///
  ///
  ///
  /// Choose component
  void addChooseComponent() async {
    final chooseComponent = TextComponent(
      anchor: Anchor.center,
      position: Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight / 2 - 200),
      text: 'Input devices',
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 50, color: Palette.white, fontWeight: FontWeight.bold),
      ),
    );
    world.add(chooseComponent);
    final gamepadTextComponent = TextComponent(
      anchor: Anchor.center,
      position: Vector2(FGJ2026.gameWidth / 2 - 300, FGJ2026.gameHeight / 2 - 50),
      text: 'Gamepad (Recommended)',
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 30, color: Palette.white, fontWeight: FontWeight.bold),
      ),
    );
    world.add(gamepadTextComponent);

    final gamepadCalibrated = await game.universalGamepadController.checkIfGamepadIsCalibrated();
    final gamepadCalibratedTextComponent = TextComponent(
      anchor: Anchor.center,
      position: Vector2(FGJ2026.gameWidth / 2 - 300, FGJ2026.gameHeight / 2 + 50),
      text: gamepadCalibrated ? 'Calibrated' : 'Not calibrated yet',
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 30, color: Palette.white, fontWeight: FontWeight.bold),
      ),
    );
    world.add(gamepadCalibratedTextComponent);

    final gamepadCalibrateComponent = CustomTextButton(
      position: Vector2(FGJ2026.gameWidth / 2 - 300, FGJ2026.gameHeight / 2 + 100),
      text: gamepadCalibrated ? 'Recalibrate' : 'Calibrate',
      onPressed: (game, world) {},
    );

    final keyboardTextComponent = TextComponent(
      anchor: Anchor.center,
      position: Vector2(FGJ2026.gameWidth / 2 + 300, FGJ2026.gameHeight / 2 - 50),
      text: 'Keyboard',
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 30, color: Palette.white, fontWeight: FontWeight.bold),
      ),
    );
    world.add(keyboardTextComponent);

    final keyboardCalibrated = await game.keyboardController.checkIfKeyboardIsCalibrated();
    final keyboardCalibratedTextComponent = TextComponent(
      anchor: Anchor.center,
      position: Vector2(FGJ2026.gameWidth / 2 + 300, FGJ2026.gameHeight / 2 + 50),
      text: keyboardCalibrated ? 'Calibrated' : 'Not calibrated yet',
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 30, color: Palette.white, fontWeight: FontWeight.bold),
      ),
    );

    world.add(keyboardCalibratedTextComponent);

    final keyboardCalibrateComponent = CustomTextButton(
      position: Vector2(FGJ2026.gameWidth / 2 + 300, FGJ2026.gameHeight / 2 + 100),
      text: keyboardCalibrated ? 'Recalibrate' : 'Calibrate',
      onPressed: (game, world) {},
    );
    keyboardCalibrateComponent.onPressed = (game, world) {
      calibrationPhase = CalibrationPhase.keyboard;
      chooseComponent.removeFromParent();
      gamepadTextComponent.removeFromParent();
      gamepadCalibratedTextComponent.removeFromParent();
      gamepadCalibrateComponent.removeFromParent();
      keyboardTextComponent.removeFromParent();
      keyboardCalibratedTextComponent.removeFromParent();
      keyboardCalibrateComponent.removeFromParent();
      callCalibrationPhase();
    };
    world.add(keyboardCalibrateComponent);

    gamepadCalibrateComponent.onPressed = (game, world) {
      calibrationPhase = CalibrationPhase.welcome;
      chooseComponent.removeFromParent();
      gamepadTextComponent.removeFromParent();
      gamepadCalibratedTextComponent.removeFromParent();
      gamepadCalibrateComponent.removeFromParent();
      keyboardTextComponent.removeFromParent();
      keyboardCalibratedTextComponent.removeFromParent();
      keyboardCalibrateComponent.removeFromParent();

      callCalibrationPhase();
    };
    world.add(gamepadCalibrateComponent);
  }

  ///
  ///
  ///
  ///
  /// Welcome component
  void addWelcomeComponent() async {
    final tempLoadingComponent = TextComponent(
      anchor: Anchor.center,
      position: Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight / 2),
      text: 'Checking for connected gamepads...',
      textRenderer: TextPaint(style: TextStyle(fontSize: 30, color: Palette.white)),
    );
    world.add(tempLoadingComponent);

    final tryAgainDetectGamepad = CustomTextButton(
      position: Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight / 2 + 100),
      text: 'Try again',
      onPressed: (game, world) {},
    );

    tryAgainDetectGamepad.onPressed = (game, world) {
      tryAgainDetectGamepad.removeFromParent();
      tempLoadingComponent.text = 'Checking for connected gamepads...';
      tryToDetectGamepad(tempLoadingComponent, tryAgainDetectGamepad);
    };

    tryToDetectGamepad(tempLoadingComponent, tryAgainDetectGamepad);

    world.add(
      welcomeTextComponent = TextComponent(
        anchor: Anchor.center,
        position: Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight / 2 - 200),
        text: 'Welcome to the gamepad calibration process',
        textRenderer: TextPaint(
          style: TextStyle(fontSize: 50, color: Palette.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void tryToDetectGamepad(TextComponent tempLoadingComponent, CustomTextButton tryAgainDetectGamepad) {
    Future.delayed(const Duration(seconds: 1), () {
      Gamepads.list().then((List<GamepadController> value) {
        if (value.isEmpty) {
          tempLoadingComponent.text = 'No gamepads found. Please connect your gamepad and try again.';
          world.add(tryAgainDetectGamepad);
        } else if (value.length > 1) {
          tempLoadingComponent.text = 'Multiple gamepads found. Please only connect one gamepad and try again.';
          world.add(tryAgainDetectGamepad);
        } else {
          tempLoadingComponent.text = 'One gamepad found. Starting calibration process...';
          Future.delayed(const Duration(seconds: 1), () {
            tempLoadingComponent.removeFromParent();
            welcomeTextComponent.removeFromParent();
            calibrationPhase = CalibrationPhase.rest;
            callCalibrationPhase();
          });
        }
      });
    });
  }

  ///
  ///
  ///
  ///
  /// Rest component
  void addListenComponent() {
    final clickOnStartWhenReadyText = TextComponent(
      anchor: Anchor.center,
      position: Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight / 2 - 200),
      text: 'Click on "Start" when ready',
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 50, color: Palette.white, fontWeight: FontWeight.bold),
      ),
    );
    world.add(clickOnStartWhenReadyText);

    final startButton = CustomTextButton(
      position: Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight / 2),
      text: 'Start',
      onPressed: (game, world) {},
    );
    startButton.onPressed = (game, world) async {
      clickOnStartWhenReadyText.removeFromParent();
      startButton.removeFromParent();
      await listenForRestGamepad();
      await Future.delayed(const Duration(seconds: 1));
      calibrationPhase = CalibrationPhase.topAndBottom;
      callCalibrationPhase();
      await listenForTopAndBottomGamepad();
      await Future.delayed(const Duration(seconds: 1));
      calibrationPhase = CalibrationPhase.rightAndLeft;
      callCalibrationPhase();
      await listenForRightAndLeftGamepad();
      await Future.delayed(const Duration(seconds: 1));
      calibrationPhase = CalibrationPhase.button1;
      callCalibrationPhase();
      await listenForButton1Gamepad();
      await Future.delayed(const Duration(seconds: 1));
      calibrationPhase = CalibrationPhase.button2;
      callCalibrationPhase();
      await listenForButton2Gamepad();
      await Future.delayed(const Duration(seconds: 1));
      calibrationPhase = CalibrationPhase.finish;
      callCalibrationPhase();
    };

    world.add(startButton);
  }

  Future<void> listenForRestGamepad() async {
    final establishingNeutralBaselineText = TextComponent(
      anchor: Anchor.center,
      position: Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight / 2 - 100),
      text: "Leave the gamepad in a neutral position. Don't touch anything.",
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 40, color: Palette.white, fontWeight: FontWeight.bold),
      ),
    );
    world.add(establishingNeutralBaselineText);

    final loadingBar = LoadingBar(
      position: Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight / 2 - 50),
      duration: 5,
      delay: 1,
      size: Vector2(200, 10),
    );
    world.add(loadingBar);

    await Future.delayed(const Duration(seconds: 1));

    List<double> xValues = [];
    List<double> yValues = [];

    final subscription = Gamepads.events.listen((event) {
      if (event.type == KeyType.button) return;
      if (event.key == 'dwXpos') {
        xValues.add(event.value);
      } else if (event.key == 'dwYpos') {
        yValues.add(event.value);
      }
    });

    await Future.delayed(const Duration(seconds: 5), () {
      establishingNeutralBaselineText.removeFromParent();
      loadingBar.removeFromParent();
      subscription.cancel();

      xRest = getCleanAverage(xValues);
      yRest = getCleanAverage(yValues);
    });
  }

  double getCleanAverage(List<double> values) {
    if (values.isEmpty) return 0.0;
    if (values.length <= 5) return values.reduce((a, b) => a + b) / values.length;
    values.sort();
    int trimCount = (values.length * 0.1).floor();
    List<double> cleanValues = values.sublist(trimCount, values.length - trimCount);
    return cleanValues.reduce((a, b) => a + b) / cleanValues.length;
  }

  Future<void> listenForTopAndBottomGamepad() async {
    final establishingTopAndBottomText = TextComponent(
      anchor: Anchor.center,
      position: Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight / 2 - 100),
      text: "Alternate pushing the stick all the way up and all the way down.",
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 40, color: Palette.white, fontWeight: FontWeight.bold),
      ),
    );
    world.add(establishingTopAndBottomText);

    final loadingBar = LoadingBar(
      position: Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight / 2 - 50),
      duration: 5,
      delay: 1,
      size: Vector2(200, 10),
    );
    world.add(loadingBar);

    await Future.delayed(const Duration(seconds: 1));

    List<double> yValues = [];

    final subscription = Gamepads.events.listen((event) {
      if (event.type == KeyType.button) return;
      if (event.key == 'dwYpos') {
        yValues.add(event.value);
      }
    });

    await Future.delayed(const Duration(seconds: 5), () {
      establishingTopAndBottomText.removeFromParent();
      loadingBar.removeFromParent();
      subscription.cancel();

      final yExtremes = getCleanExtremes(yValues);
      yMin = yExtremes.min;
      yMax = yExtremes.max;
    });
  }

  Future<void> listenForRightAndLeftGamepad() async {
    final establishingRightAndLeftText = TextComponent(
      anchor: Anchor.center,
      position: Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight / 2 - 100),
      text: "Alternate pushing the stick all the way right and all the way left.",
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 40, color: Palette.white, fontWeight: FontWeight.bold),
      ),
    );
    world.add(establishingRightAndLeftText);

    final loadingBar = LoadingBar(
      position: Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight / 2 - 50),
      duration: 5,
      delay: 1,
      size: Vector2(200, 10),
    );
    world.add(loadingBar);

    await Future.delayed(const Duration(seconds: 1));

    List<double> xValues = [];

    final subscription = Gamepads.events.listen((event) {
      if (event.type == KeyType.button) return;
      if (event.key == 'dwXpos') {
        xValues.add(event.value);
      }
    });

    await Future.delayed(const Duration(seconds: 5), () {
      establishingRightAndLeftText.removeFromParent();
      loadingBar.removeFromParent();
      subscription.cancel();

      final xExtremes = getCleanExtremes(xValues);
      xMin = xExtremes.min;
      xMax = xExtremes.max;
    });
  }

  ({double min, double max}) getCleanExtremes(List<double> values) {
    if (values.isEmpty) return (min: -1.0, max: 1.0);

    values.sort();

    if (values.length <= 5) {
      return (min: values.first, max: values.last);
    }

    int sampleSize = (values.length * 0.1).ceil().clamp(1, values.length ~/ 3);

    List<double> lowValues = values.sublist(0, sampleSize);
    double minAvg = lowValues.reduce((a, b) => a + b) / lowValues.length;

    List<double> highValues = values.sublist(values.length - sampleSize, values.length);
    double maxAvg = highValues.reduce((a, b) => a + b) / highValues.length;

    return (min: minAvg, max: maxAvg);
  }

  Future<void> listenForButton1Gamepad() async {
    final establishingButton1Text = TextComponent(
      anchor: Anchor.center,
      position: Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight / 2 - 100),
      text: "Press a button to bind Run",
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 40, color: Palette.white, fontWeight: FontWeight.bold),
      ),
    );
    world.add(establishingButton1Text);

    final subscription = Gamepads.events.listen((event) {});

    subscription.onData((event) {
      if (event.type == KeyType.button) {
        if (event.value == 1) {
          button1Key = event.key;
          subscription.cancel();
        }
      }
    });

    while (button1Key.isEmpty) {
      await Future.delayed(const Duration(seconds: 1));
    }

    establishingButton1Text.text = 'Run bound to $button1Key';
    await Future.delayed(const Duration(seconds: 2));
    establishingButton1Text.removeFromParent();
  }

  Future<void> listenForButton2Gamepad() async {
    final establishingButton2Text = TextComponent(
      anchor: Anchor.center,
      position: Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight / 2 - 100),
      text: "Press a button to bind Interact",
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 40, color: Palette.white, fontWeight: FontWeight.bold),
      ),
    );
    world.add(establishingButton2Text);

    final subscription = Gamepads.events.listen((event) {});

    subscription.onData((event) {
      if (event.type == KeyType.button) {
        if (event.value == 1) {
          button2Key = event.key;
          subscription.cancel();
        }
      }
    });

    while (button2Key.isEmpty) {
      await Future.delayed(const Duration(seconds: 1));
    }

    establishingButton2Text.text = 'Interact bound to $button2Key';
    await Future.delayed(const Duration(seconds: 2));
    establishingButton2Text.removeFromParent();
  }

  Future<void> saveGamepadConfigurationToPrefs() async {
    await game.universalGamepadController.saveGamepadConfigurationToPrefs(button1Key, button2Key, xRest, yRest, xMin, xMax, yMin, yMax);

    final finishText = TextComponent(
      anchor: Anchor.center,
      position: Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight / 2 - 100),
      text: "Gamepad configuration saved successfully",
      textRenderer: TextPaint(
        style: TextStyle(fontSize: 40, color: Palette.white, fontWeight: FontWeight.bold),
      ),
    );
    world.add(finishText);

    await Future.delayed(const Duration(seconds: 3));
    game.router.pushReplacementNamed('mainMenu');
  }

  void addKeyboardComponent() {
    final keyboardKeysComponent = ColumnComponent(
      crossAxisAlignment: CrossAxisAlignment.end,
      gap: 25,
      anchor: Anchor.center,
      position: Vector2(FGJ2026.gameWidth / 2 - 250, FGJ2026.gameHeight / 2 - 40),
      children: [
        TextComponent(
          text: 'UP',
          textRenderer: TextPaint(
            style: TextStyle(fontSize: 50, color: Palette.white, fontWeight: FontWeight.bold),
          ),
        ),
        TextComponent(
          text: 'DOWN',
          textRenderer: TextPaint(
            style: TextStyle(fontSize: 50, color: Palette.white, fontWeight: FontWeight.bold),
          ),
        ),
        TextComponent(
          text: 'LEFT',
          textRenderer: TextPaint(
            style: TextStyle(fontSize: 50, color: Palette.white, fontWeight: FontWeight.bold),
          ),
        ),
        TextComponent(
          text: 'RIGHT',
          textRenderer: TextPaint(
            style: TextStyle(fontSize: 50, color: Palette.white, fontWeight: FontWeight.bold),
          ),
        ),
        TextComponent(
          text: 'RUN',
          textRenderer: TextPaint(
            style: TextStyle(fontSize: 50, color: Palette.white, fontWeight: FontWeight.bold),
          ),
        ),
        TextComponent(
          text: 'INTERACT',
          textRenderer: TextPaint(
            style: TextStyle(fontSize: 50, color: Palette.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
    world.add(keyboardKeysComponent);

    final keyboardChooseKeysComponent = ColumnComponent(
      crossAxisAlignment: CrossAxisAlignment.start,
      gap: 38,
      anchor: Anchor.center,
      position: Vector2(FGJ2026.gameWidth / 2 + 300, FGJ2026.gameHeight / 2 - 15),
      children: [
        ButtonChooseKey(keyIdentifier: 'upKeyboard'),
        ButtonChooseKey(keyIdentifier: 'downKeyboard'),
        ButtonChooseKey(keyIdentifier: 'leftKeyboard'),
        ButtonChooseKey(keyIdentifier: 'rightKeyboard'),
        ButtonChooseKey(keyIdentifier: 'button1Keyboard'),
        ButtonChooseKey(keyIdentifier: 'button2Keyboard'),
      ],
    );
    world.add(keyboardChooseKeysComponent);
  }
}
