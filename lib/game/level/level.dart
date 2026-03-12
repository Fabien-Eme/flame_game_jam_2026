import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../../utils/debug_pointer.dart';
import '../../utils/palette.dart';
import '../game.dart';
import 'level_world.dart';

class Level extends PositionComponent with HasGameReference<FGJ2026>, PointerMoveCallbacks, TapCallbacks {
  Level({super.key, this.speedRunMode = false, this.newGame = false});

  late final LevelWorld levelWorld;
  late final CameraComponent cameraComponent;

  final bool speedRunMode;
  final bool newGame;

  late final DebugPointer debugPointer;

  @override
  FutureOr<void> onLoad() async {
    if (newGame) {
      await game.checkpointController.resetCheckpoint();
      await game.keycardController.resetKeyCards();
    }
    levelWorld = LevelWorld(key: ComponentKey.named('levelWorld'));

    add(cameraComponent = CameraComponent.withFixedResolution(width: FGJ2026.gameWidth, height: FGJ2026.gameHeight, world: levelWorld));
    cameraComponent.viewfinder.anchor = Anchor.topLeft;

    /// TODO, debug, to delete
    size = Vector2(FGJ2026.gameWidth, FGJ2026.gameHeight);
    await cameraComponent.viewport.add(debugPointer = DebugPointer(position: Vector2.zero()));

    add(levelWorld);

    return super.onLoad();
  }

  @override
  void onPointerMove(PointerMoveEvent event) {
    super.onPointerMove(event);
    debugPointer.position = event.localPosition;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    if (cameraComponent.viewfinder.zoom == 1) {
      cameraComponent.viewfinder.position = debugPointer.position - Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight / 2) / 5;
      cameraComponent.viewfinder.zoom = 5;
    } else {
      cameraComponent.viewfinder.zoom = 1;
      cameraComponent.viewfinder.position = Vector2.zero();
    }
  }
}
