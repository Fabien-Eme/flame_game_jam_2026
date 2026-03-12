import 'package:flame/components.dart';
import 'package:flame_game_jam_2026/game/game.dart';

enum InputType { keyboard, gamepad }

class InputController extends Component with HasGameReference<FGJ2026> {
  InputController({super.key});

  @override
  void onLoad() {
    super.onLoad();
  }
}
