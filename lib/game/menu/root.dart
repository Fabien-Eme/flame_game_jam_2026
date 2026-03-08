import 'package:flame/components.dart';

import '../game.dart';

class Root extends Component with HasGameReference<FGJ2026> {
  @override
  void onLoad() {
    super.onLoad();
    game.router.pushNamed('level1');
  }
}
