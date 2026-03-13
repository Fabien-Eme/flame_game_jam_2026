import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';

import '../../utils/palette.dart';
import '../component/won.dart';
import '../level/level.dart';
import '../level/level_world.dart';
import '../game.dart';
import 'highscore_service.dart';

class VictoryController extends Component with HasWorldReference<LevelWorld>, HasGameReference<FGJ2026> {
  VictoryController();

  bool hasWon = false;
  bool hasWonDelayedElapsed = false;

  double timeElapsed = 0;

  @override
  void onLoad() {
    priority = 1000;
    super.onLoad();
  }

  void won() {
    if (hasWon) return;
    HighscoreService.saveScore("Fabien", timeElapsed);
    game.audioController.playVictorySound();
    hasWon = true;
    hasWonDelayedElapsed = false;
    world.isPaused = true;
    add(
      RectangleComponent(
        position: (world.parent! as Level).cameraComponent.viewfinder.position,
        size: Vector2(FGJ2026.gameWidth, FGJ2026.gameHeight),
        paint: Paint()..color = Palette.whiteTransparent,
      ),
    );
    add(
      WonComponent(position: (world.parent! as Level).cameraComponent.viewfinder.position + Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight / 2)),
    );

    game.checkpointController.resetCheckpoint();
    game.keycardController.resetKeyCards();

    Future.delayed(const Duration(milliseconds: 2000), () {
      hasWonDelayedElapsed = true;
    });
  }

  void tryToQuit() {
    if (!hasWon) return;
    if (hasWonDelayedElapsed) {
      if ((world.parent! as Level).speedRunMode) {
        game.router.pushReplacementNamed('mainMenu');
      } else {
        game.router.pushReplacementNamed('mainMenu');
      }
    }
  }
}
