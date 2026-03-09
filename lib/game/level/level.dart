import 'dart:async';

import 'package:flame/components.dart';

import '../game.dart';
import 'level_world_1.dart';

class Level extends PositionComponent with HasGameReference<FGJ2026> {
  Level({super.key, required this.currentLevel});

  final int currentLevel;

  late final World levelWorld;
  late final CameraComponent cameraComponent;

  @override
  FutureOr<void> onLoad() {
    levelWorld = switch (currentLevel) {
      1 => LevelWorld1(),
      _ => throw Exception('Level $currentLevel not found'),
    };

    add(cameraComponent = CameraComponent.withFixedResolution(width: FGJ2026.gameWidth, height: FGJ2026.gameHeight, world: levelWorld));

     add(levelWorld);


    return super.onLoad();
  }

}

