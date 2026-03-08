import 'dart:async';

import 'package:flame/components.dart';

import '../game.dart';

class MainMenu extends PositionComponent with HasGameReference<FGJ2026> {
  final World world = World();
  late final CameraComponent cameraComponent;

  @override
  FutureOr<void> onLoad() {
    add(world);

    add(cameraComponent = CameraComponent.withFixedResolution(width: FGJ2026.gameWidth, height: FGJ2026.gameHeight, world: world));

    world.add(TextComponent(text: 'NEW GAME', anchor: Anchor.center, position: Vector2(0, 0)));

    return super.onLoad();
  }
}
