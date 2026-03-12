import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';

import '../../utils/palette.dart';
import '../component/busted.dart';
import '../level/level.dart';
import '../level/level_world.dart';
import '../game.dart';

class BustedController extends Component with HasWorldReference<LevelWorld>, HasGameReference<FGJ2026> {
  BustedController();

  bool isBusted = false;
  bool isBustedDelayedElapsed = false;

  @override
  void onLoad() {
    priority = 1000;
    super.onLoad();
  }

  void busted() {
    if (isBusted) return;
    game.audioController.playCameraDetectionSound();
    isBusted = true;
    isBustedDelayedElapsed = false;
    world.isPaused = true;
    add(
      RectangleComponent(
        position: (world.parent! as Level).cameraComponent.viewfinder.position,
        size: Vector2(FGJ2026.gameWidth, FGJ2026.gameHeight),
        paint: Paint()..color = Palette.blackAlmostOpaque,
      ),
    );
    add(
      BustedComponent(
        position: (world.parent! as Level).cameraComponent.viewfinder.position + Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight / 5),
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      isBustedDelayedElapsed = true;
    });
  }

  void tryToDebust() {
    if (!isBusted) return;
    if (isBustedDelayedElapsed) {
      if ((world.parent! as Level).speedRunMode) {
        game.router.pushReplacementNamed('loadingSpeedRunMode');
      } else {
        game.router.pushReplacementNamed('loading');
      }
    }
  }
}
