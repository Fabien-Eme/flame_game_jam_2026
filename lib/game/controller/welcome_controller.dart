import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';

import '../../utils/palette.dart';
import '../component/welcome.dart';
import '../level/level.dart';
import '../level/level_world.dart';
import '../game.dart';

class WelcomeController extends Component with HasWorldReference<LevelWorld>, HasGameReference<FGJ2026> {
  WelcomeController();

  bool hasBeenWelcomed = false;
  bool hasWelcomedDelayedElapsed = false;

  double timeElapsed = 0;

  late final RectangleComponent rectangleComponent;
  late final WelcomeComponent welcomeComponent;

  @override
  void onLoad() {
    priority = 1000;
    super.onLoad();
  }

  void welcome() {
    if (hasBeenWelcomed) return;
    hasBeenWelcomed = true;
    hasWelcomedDelayedElapsed = false;
    world.isPaused = true;

    add(
      rectangleComponent = RectangleComponent(
        position: (world.parent! as Level).cameraComponent.viewfinder.position,
        size: Vector2(FGJ2026.gameWidth, FGJ2026.gameHeight),
        paint: Paint()..color = Palette.whiteTransparent,
      ),
    );
    add(
      welcomeComponent = WelcomeComponent(
        position: (world.parent! as Level).cameraComponent.viewfinder.position + Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight / 2),
      ),
    );

    Future.delayed(const Duration(milliseconds: 2000), () {
      hasWelcomedDelayedElapsed = true;
    });
  }

  void tryToQuit() {
    if (!hasBeenWelcomed) return;
    if (hasWelcomedDelayedElapsed) {
      welcomeComponent.removeFromParent();
      rectangleComponent.removeFromParent();
      world.isPaused = false;
    }
  }
}
