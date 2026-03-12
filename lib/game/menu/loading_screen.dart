import 'package:flame/components.dart';

import '../game.dart';

class LoadingScreen extends Component with HasGameReference<FGJ2026> {
  LoadingScreen({super.key, this.isSpeedRunMode = false});

  final bool isSpeedRunMode;

  @override
  void onLoad() {
    super.onLoad();
    if (isSpeedRunMode) {
      game.router.pushReplacementNamed('speedRunMode');
    } else {
      game.router.pushReplacementNamed('level');
    }
  }
}
