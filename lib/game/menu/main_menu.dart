import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/rendering.dart';

import '../../utils/palette.dart';
import '../game.dart';
import '../level/post_process.dart';
import 'menu_entry.dart';

class MainMenu extends PositionComponent with HasGameReference<FGJ2026> {
  final World world = World();
  late final CameraComponent cameraComponent;

  final List<MenuEntry> menuEntries = [];

  @override
  FutureOr<void> onLoad() async {
    add(world);

    add(cameraComponent = CameraComponent.withFixedResolution(width: FGJ2026.gameWidth, height: FGJ2026.gameHeight, world: world));
    cameraComponent.postProcess = CRTPostProcess();

    world.add(
      RectangleComponent.fromRect(
        Rect.fromLTWH(-FGJ2026.gameWidth / 2, -FGJ2026.gameHeight / 2, FGJ2026.gameWidth, FGJ2026.gameHeight),
        paint: Paint()..color = Palette.veryDarkGrey,
        children: [RectangleHitbox(collisionType: CollisionType.passive)],
      ),
    );

    if (game.checkpointController.currentCheckpoint > 0) {
      menuEntries.add(MenuEntry(text: 'CONTINUE', isSelected: true));
    }

    menuEntries.add(MenuEntry(text: 'NEW GAME', isSelected: true));

    menuEntries.addAll([MenuEntry(text: 'SPEED RUN MODE'), MenuEntry(text: 'GAMEPAD CONFIGURATION'), MenuEntry(text: 'SETTINGS')]);

    await world.add(
      ColumnComponent(
        anchor: Anchor.center,
        gap: 75,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: menuEntries,
      ),
    );

    select(menuEntries.first);

    return super.onLoad();
  }

  void select(MenuEntry entry) {
    if (entry.isSelected) return;
    for (final e in menuEntries) {
      e.deselect();
    }
    entry.select();
  }

  void deselect(MenuEntry entry) {
    entry.deselect();
  }
}
