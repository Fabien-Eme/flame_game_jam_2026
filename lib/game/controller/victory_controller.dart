import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/palette.dart';
import '../component/speedrun_won.dart';
import '../component/won.dart';
import '../level/level.dart';
import '../level/level_world.dart';
import '../game.dart';
import 'highscore_service.dart';

class VictoryController extends Component with HasWorldReference<LevelWorld>, HasGameReference<FGJ2026> {
  VictoryController();

  bool hasWon = false;
  bool hasWonDelayedElapsed = false;
  bool hasUploadedSpeedrunScore = false;

  double timeElapsed = 0;

  late final RectangleComponent rectangleComponent;
  PositionComponent? victoryScreen;

  @override
  void onLoad() {
    priority = 1000;
    super.onLoad();
  }

  void won() {
    if (hasWon) return;

    final isSpeedRunMode = (world.parent! as Level).speedRunMode;
    final asyncPrefs = SharedPreferencesAsync();
    asyncPrefs.setBool('hasWon', true);
    game.audioController.playVictorySound();
    hasWon = true;
    hasWonDelayedElapsed = !isSpeedRunMode;
    hasUploadedSpeedrunScore = false;
    world.isPaused = true;
    add(
      rectangleComponent = RectangleComponent(
        position: (world.parent! as Level).cameraComponent.viewfinder.position,
        size: Vector2(FGJ2026.gameWidth, FGJ2026.gameHeight),
        paint: Paint()..color = Palette.whiteTransparent,
      ),
    );
    if (isSpeedRunMode) {
      add(
        victoryScreen = SpeedrunWonComponent(
          position:
              (world.parent! as Level).cameraComponent.viewfinder.position +
              Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight / 2),
          timeElapsed: timeElapsed,
          onSubmit: (playerName) async {
            await HighscoreService.saveScore(playerName, timeElapsed);
          },
          onUploaded: () {
            hasUploadedSpeedrunScore = true;
            hasWonDelayedElapsed = true;
          },
        ),
      );
    } else {
      add(
        victoryScreen = WonComponent(
          position:
              (world.parent! as Level).cameraComponent.viewfinder.position +
              Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight / 2),
        ),
      );
    }

    game.checkpointController.resetCheckpoint();
    game.keycardController.resetKeyCards();

    if (!isSpeedRunMode) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        hasWonDelayedElapsed = true;
      });
    }
  }

  void tryToQuit() {
    if (!hasWon) return;
    if (hasWonDelayedElapsed) {
      if ((world.parent! as Level).speedRunMode) {
        if (!hasUploadedSpeedrunScore) return;
        game.router.pushReplacementNamed('mainMenu');
      } else {
        game.router.pushReplacementNamed('mainMenu');
      }
    }
  }
}
