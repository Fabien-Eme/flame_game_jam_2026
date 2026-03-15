import 'package:flame/components.dart';
import 'package:flame_game_jam_2026/game/game.dart';
import 'package:gamepads/gamepads.dart';

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../level/level_world.dart';

class UniversalGamepadController extends Component with HasGameReference<FGJ2026> {
  StreamSubscription<GamepadEvent>? _subscription;
  static const Set<String> _fallbackXAxisKeys = {'dwXpos', 'analog 0'};
  static const Set<String> _fallbackYAxisKeys = {'dwYpos', 'analog 1'};

  LevelWorld? levelWorld;

  double _rawX = 0;
  double _rawY = 0;
  double deadzone = 0.15;

  String button1Key = '';
  String button2Key = '';
  String xAxisKey = '';
  String yAxisKey = '';
  double xRest = 0;
  double yRest = 0;
  double xMin = 0;
  double xMax = 0;
  double yMin = 0;
  double yMax = 0;

  @override
  FutureOr<void> onLoad() async {
    _subscription = Gamepads.events.listen(_onGamepadEvent);
    return super.onLoad();
  }

  Future<void> saveGamepadConfigurationToPrefs(
    String button1Key,
    String button2Key,
    String xAxisKey,
    String yAxisKey,
    double xRest,
    double yRest,
    double xMin,
    double xMax,
    double yMin,
    double yMax,
  ) async {
    this.button1Key = button1Key;
    this.button2Key = button2Key;
    this.xAxisKey = xAxisKey;
    this.yAxisKey = yAxisKey;
    this.xRest = xRest;
    this.yRest = yRest;
    this.xMin = xMin;
    this.xMax = xMax;
    this.yMin = yMin;
    this.yMax = yMax;

    final asyncPrefs = SharedPreferencesAsync();
    asyncPrefs.setString('button1Key', button1Key);
    asyncPrefs.setString('button2Key', button2Key);
    asyncPrefs.setString('xAxisKey', xAxisKey);
    asyncPrefs.setString('yAxisKey', yAxisKey);
    asyncPrefs.setDouble('xRest', xRest);
    asyncPrefs.setDouble('yRest', yRest);
    asyncPrefs.setDouble('xMin', xMin);
    asyncPrefs.setDouble('xMax', xMax);
    asyncPrefs.setDouble('yMin', yMin);
    asyncPrefs.setDouble('yMax', yMax);
    asyncPrefs.setBool('isGamepadCalibrated', true);
    asyncPrefs.setBool('isGamepadChosen', true);
  }

  Future<void> retrieveGamepadConfigurationFromPrefs() async {
    final asyncPrefs = SharedPreferencesAsync();
    button1Key = await asyncPrefs.getString('button1Key') ?? '';
    button2Key = await asyncPrefs.getString('button2Key') ?? '';
    xAxisKey = await asyncPrefs.getString('xAxisKey') ?? '';
    yAxisKey = await asyncPrefs.getString('yAxisKey') ?? '';
    xRest = await asyncPrefs.getDouble('xRest') ?? 0;
    yRest = await asyncPrefs.getDouble('yRest') ?? 0;
    xMin = await asyncPrefs.getDouble('xMin') ?? 0;
    xMax = await asyncPrefs.getDouble('xMax') ?? 0;
    yMin = await asyncPrefs.getDouble('yMin') ?? 0;
    yMax = await asyncPrefs.getDouble('yMax') ?? 0;
  }

  Future<bool> checkIfGamepadIsCalibrated() async {
    final asyncPrefs = SharedPreferencesAsync();
    return await asyncPrefs.getBool('isGamepadCalibrated') ?? false;
  }

  void _onGamepadEvent(GamepadEvent event) {
    if (levelWorld == null || !levelWorld!.isMounted) return;

    if (event.key == button1Key) {
      if (event.value == 1) {
        button0Pressed();
      } else {
        button0Released();
      }
    } else if (event.key == button2Key) {
      if (event.value == 1) {
        button1Pressed();
      } else {
        button1Released();
      }
    } else if (event.key == button2Key && event.value == 1) {
      button1Pressed();
    } else if (_isXAxisEvent(event)) {
      _rawX = event.value;
      _emitMove();
    } else if (_isYAxisEvent(event)) {
      _rawY = event.value;
      _emitMove();
    }
  }

  bool _isXAxisEvent(GamepadEvent event) {
    return event.type == KeyType.analog &&
        (event.key == xAxisKey || (xAxisKey.isEmpty && _fallbackXAxisKeys.contains(event.key)));
  }

  bool _isYAxisEvent(GamepadEvent event) {
    return event.type == KeyType.analog &&
        (event.key == yAxisKey || (yAxisKey.isEmpty && _fallbackYAxisKeys.contains(event.key)));
  }

  void _emitMove() {
    if (levelWorld == null || levelWorld!.isPaused || !levelWorld!.isMounted) return;
    final x = _normalizeAxis(value: _rawX, center: xRest, min: xMin, max: xMax);

    final y = _normalizeAxis(value: _rawY, center: yRest, min: yMin, max: yMax);

    final direction = Vector2(x, y);

    // Deadzone radiale
    if (direction.length < deadzone) {
      levelWorld!.playerMovementController.movePlayer(Vector2.zero());
      return;
    }

    // Évite d'aller plus vite en diagonale
    if (direction.length > 1) {
      direction.normalize();
    }
    levelWorld!.playerMovementController.movePlayer(direction);
  }

  double _normalizeAxis({required double value, required double center, required double min, required double max}) {
    if (value >= center) {
      final positiveRange = max - center;
      if (positiveRange <= 0) return 0;
      return ((value - center) / positiveRange).clamp(0.0, 1.0);
    } else {
      final negativeRange = center - min;
      if (negativeRange <= 0) return 0;
      return ((value - center) / negativeRange).clamp(-1.0, 0.0);
    }
  }

  void button0Pressed() {
    levelWorld!.bustedController.tryToDebust();
    levelWorld!.victoryController.tryToQuit();
    levelWorld!.welcomeController.tryToQuit();
    if (levelWorld!.isPaused) return;
    levelWorld!.playerMovementController.run();
  }

  void button0Released() {
    levelWorld!.playerMovementController.walk();
  }

  void button1Pressed() {
    levelWorld!.bustedController.tryToDebust();
    levelWorld!.victoryController.tryToQuit();
    levelWorld!.welcomeController.tryToQuit();
    if (levelWorld!.isPaused) return;
    for (final door in levelWorld!.doors) {
      if (door.isSelected) {
        door.toggleState();
      }
    }
    for (final keyCard in levelWorld!.keyCards) {
      if (keyCard.isSelected) {
        keyCard.pickUp();
      }
    }
  }

  void button1Released() {}

  @override
  void onRemove() {
    _subscription?.cancel();
    super.onRemove();
  }
}
