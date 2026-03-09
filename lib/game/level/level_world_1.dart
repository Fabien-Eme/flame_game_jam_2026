import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_game_jam_2026/game/component/bb_camera.dart';
import 'package:flame_game_jam_2026/game/controller/player_movement_controller.dart';

import '../component/room.dart';
import '../controller/custom_gamepad_controller.dart';
import '../controller/ray_controller.dart';
import '../game.dart';
import '../snackbar/snackbar_controller.dart';
import '../component/player.dart';
import 'level_world.dart';

class LevelWorld1 extends LevelWorld with HasGameReference<FGJ2026>, HasCollisionDetection {
  late final SnackbarController snackBarController;
  late final RayController rayController;

  late final PlayerMovementController playerMovementController;

  late final PlayerComponent player;

  final List<BBCamera> bbCameras = [];

  @override
  FutureOr<void> onLoad() async {
    await parent!.mounted;

    await addAll([snackBarController = SnackbarController()]);
    await add(player = PlayerComponent(position: Vector2.zero()));

    add(playerMovementController = PlayerMovementController(player: player));
    add(CustomGamepadController(playerMovementController: playerMovementController, button1Pressed: button1Pressed));
    add(rayController = RayController());

    bbCameras.add(BBCamera(position: Vector2(200, 0), id: 0, maxDistance: 150, angleSpeed: 1.1, startAngle: pi / 4));
    add(bbCameras.last);
    rayController.addBBCamera(bbCameras.last);

    bbCameras.add(BBCamera(position: Vector2(-100, 0), id: 1, maxDistance: 300, angleSpeed: 2, startAngle: -pi / 4));
    add(bbCameras.last);
    rayController.addBBCamera(bbCameras.last);
    bbCameras.add(BBCamera(position: Vector2(0, 50), id: 2, maxDistance: 250));
    add(bbCameras.last);
    rayController.addBBCamera(bbCameras.last);

    add(ScreenHitbox());

    rooms.add(Room(position: Vector2.all(100), size: Vector2(200, 100)));
    add(rooms.last);
    if (rooms.last.door != null) {
      doors.add(rooms.last.door!);
    }

    rooms.add(Room(position: Vector2(-300, 0), size: Vector2(100, 100)));
    add(rooms.last);
    if (rooms.last.door != null) {
      doors.add(rooms.last.door!);
    }

    return super.onLoad();
  }

  void button1Pressed() {
    for (final door in doors) {
      if (door.isSelected) {
        door.toggleState();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    rayController.renderAllRays(canvas);
  }
}
