import 'package:flame/components.dart';

import '../game.dart';

class Root extends Component with HasGameReference<FGJ2026> {
  @override
  void onLoad() {
    super.onLoad();

    // game.router.pushNamed('level');
    // game.router.pushNamed('speedRunMode');
    game.router.pushNamed('mainMenu');
    // game.router.pushNamed('gamepadConfiguration');
    // game.router.pushNamed('settings');
  }
}
