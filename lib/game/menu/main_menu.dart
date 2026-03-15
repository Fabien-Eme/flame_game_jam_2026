import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/palette.dart';
import '../component/explanations.dart';
import '../game.dart';
import '../component/highscore.dart';
import '../level/post_process.dart';
import 'menu_entry.dart';

class MainMenu extends PositionComponent with HasGameReference<FGJ2026> {
  final World world = World();
  late final CameraComponent cameraComponent;

  final List<MenuEntry> menuEntries = [];

  bool hasWon = false;

  @override
  FutureOr<void> onLoad() async {
    await add(world);

    await add(cameraComponent = CameraComponent.withFixedResolution(width: FGJ2026.gameWidth, height: FGJ2026.gameHeight, world: world));

    cameraComponent.postProcess = game.postProcessing ? CRTPostProcess() : null;

    world.add(
      RectangleComponent.fromRect(
        Rect.fromLTWH(-FGJ2026.gameWidth / 2, -FGJ2026.gameHeight / 2, FGJ2026.gameWidth, FGJ2026.gameHeight),
        paint: Paint()..color = Palette.veryDarkGrey,
        children: [RectangleHitbox(collisionType: CollisionType.passive)],
      ),
    );

    final asyncPrefs = SharedPreferencesAsync();
    hasWon = await asyncPrefs.getBool('hasWon') ?? false;

    final bool isGamepadCalibrated = await asyncPrefs.getBool('isGamepadCalibrated') ?? false;
    final bool isKeyboardCalibrated = await asyncPrefs.getBool('isKeyboardCalibrated') ?? false;
    final bool isAtleastOneInputDeviceCalibrated = isGamepadCalibrated || isKeyboardCalibrated;

    if (!isAtleastOneInputDeviceCalibrated) {
      world.add(
        TextComponent(
          anchor: Anchor.center,
          position: Vector2(0, -200),
          text: 'Configure at least one input device to play',
          textRenderer: TextPaint(style: TextStyle(fontSize: 30, color: Palette.white)),
        ),
      );
    }

    if (game.checkpointController.currentCheckpoint > 0) {
      menuEntries.add(MenuEntry(text: 'CONTINUE', isAvailable: isAtleastOneInputDeviceCalibrated));
    }

    menuEntries.add(MenuEntry(text: 'NEW GAME', isAvailable: isAtleastOneInputDeviceCalibrated));

    menuEntries.add(MenuEntry(text: 'SPEED RUN MODE', isAvailable: hasWon && isAtleastOneInputDeviceCalibrated));

    menuEntries.addAll([MenuEntry(text: 'INPUT CONFIGURATION'), MenuEntry(text: 'SETTINGS')]);

    await world.add(
      ColumnComponent(
        anchor: Anchor.center,
        gap: 75,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: menuEntries,
      ),
    );

    world.add(HighscoreComponent(position: Vector2(FGJ2026.gameWidth / 2 - 150, -170)));

    world.add(Explanations(position: Vector2(-FGJ2026.gameWidth / 2 + 50, 0), inGame: false));

    return super.onLoad();
  }

  @override
  FutureOr<void> onMount() async {
    // await all menu entries to be loaded
    List<Future<void>> futures = [];
    for (final entry in menuEntries) {
      futures.add(entry.loaded);
    }
    await Future.wait(futures);
    select(menuEntries.first);
    return super.onMount();
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

  void selectNext() {
    int currentIndex = menuEntries.indexOf(menuEntries.firstWhere((e) => e.isSelected));
    if (currentIndex == menuEntries.length - 1) {
      select(menuEntries.first);
    } else {
      select(menuEntries[currentIndex + 1]);
    }
  }

  void selectPrevious() {
    int currentIndex = menuEntries.indexOf(menuEntries.firstWhere((e) => e.isSelected));
    if (currentIndex == 0) {
      select(menuEntries.last);
    } else {
      select(menuEntries[currentIndex - 1]);
    }
  }
}
