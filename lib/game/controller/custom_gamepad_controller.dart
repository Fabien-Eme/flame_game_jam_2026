import 'dart:async';

import 'package:flame/components.dart';
import 'package:gamepads/gamepads.dart';

import 'player_movement_controller.dart';

class CustomGamepadController extends Component with HasWorldReference {
  final Function() button1Pressed;

  late final PlayerMovementController playerMovementController;

  final double deadzone;
  final double min;
  final double max;
  final double centerX;
  final double centerY;
  final bool invertY;

  StreamSubscription<GamepadEvent>? _subscription;

  double _rawX = 0;
  double _rawY = 0;

  CustomGamepadController({
    required this.playerMovementController,
    this.deadzone = 0.15,
    this.min = 3000,
    this.max = 60000,
    this.centerX = 29400.0,
    this.centerY = 33006.0,
    this.invertY = false,
    required this.button1Pressed,
  }) : _rawX = centerX,
       _rawY = centerY;

  @override
  FutureOr<void> onLoad() async {
    _subscription = Gamepads.events.listen(_onGamepadEvent);
    return super.onLoad();
  }

  void _onGamepadEvent(GamepadEvent event) {
    switch (event.key) {
      case 'dwXpos':
        _rawX = event.value;
        _emitMove();
        break;

      case 'dwYpos':
        _rawY = event.value;
        _emitMove();
        break;

      case 'dwRpos':
      case 'dwUpos':
        // Stick droit ignoré ici
        break;

      case 'button-1':
        if (event.value == 1) {
          button1Pressed();
        }
        break;

      default:
        // print(event);
        break;
    }
  }

  void _emitMove() {
    final x = _normalizeAxis(value: _rawX, center: centerX, min: min, max: max);

    double y = _normalizeAxis(value: _rawY, center: centerY, min: min, max: max);

    if (invertY) {
      y = -y;
    }

    final direction = Vector2(x, y);

    // Deadzone radiale
    if (direction.length < deadzone) {
      playerMovementController.movePlayer(Vector2.zero());
      return;
    }

    // Évite d'aller plus vite en diagonale
    if (direction.length > 1) {
      direction.normalize();
    }

    playerMovementController.movePlayer(direction);
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

  @override
  void onRemove() {
    _subscription?.cancel();
    super.onRemove();
  }
}
