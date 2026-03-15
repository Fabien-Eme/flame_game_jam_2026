import 'dart:math';
import 'package:flame/components.dart';
import '../../game/component/bb_camera.dart';
import '../../game/component/room.dart';
import '../../game/component/wall.dart';
import '../../game/level/level_world.dart';
import '../../utils/constants.dart';
import '../../utils/palette.dart';
import '../../game/component/key_card.dart';
import '../component/arrow.dart';
import '../component/check_point.dart';
import '../component/door.dart';
import 'dart:ui';

Future<void> level2Initialization(LevelWorld levelWorld, List<Color> keyCardsOwned) async {
  if (!keyCardsOwned.contains(Palette.darkYellow)) return;

  if (!keyCardsOwned.contains(Palette.orange)) {
    await levelWorld.addBBCameras([
      BBCamera(
        position: Vector2(550, 405),
        maxDistance: 250,
        isRotating: true,
        startAngle: 5 * pi / 8,
        rotationAmplitude: pi / 2,
        angleSpeed: 1.75,
        angleCovered: pi / 4,
        removeOnKeyCardTriggerColor: Palette.orange,
      ),

      BBCamera(
        position: Vector2(755, 550),
        maxDistance: 60,
        isRotating: false,
        startAngle: pi / 8,
        isMoving: true,
        isMovingVertically: true,
        movingSpeed: 100,
        movingAmplitude: 150,
        goingUpOrRight: false,
        removeOnKeyCardTriggerColor: Palette.orange,
      ),
      BBCamera(
        position: Vector2(845, 550),
        maxDistance: 60,
        isRotating: false,
        startAngle: -7 * pi / 8,
        isMoving: true,
        isMovingVertically: true,
        movingSpeed: 150,
        movingAmplitude: 150,
        goingUpOrRight: false,
        removeOnKeyCardTriggerColor: Palette.orange,
      ),

      BBCamera(
        position: Vector2(755, 250),
        maxDistance: 60,
        isRotating: false,
        startAngle: pi / 8,
        isMoving: true,
        isMovingVertically: true,
        movingSpeed: 175,
        movingAmplitude: 150,
        goingUpOrRight: false,
        removeOnKeyCardTriggerColor: Palette.orange,
      ),
      BBCamera(
        position: Vector2(845, 250),
        maxDistance: 60,
        isRotating: false,
        startAngle: -7 * pi / 8,
        isMoving: true,
        isMovingVertically: true,
        movingSpeed: 110,
        movingAmplitude: 150,
        goingUpOrRight: false,
        removeOnKeyCardTriggerColor: Palette.orange,
      ),

      BBCamera(
        position: Vector2(800, 400),
        maxDistance: 80,
        angleCovered: pi / 8,
        isRotating: false,
        startAngle: -7 * pi / 16,
        isMoving: true,
        isMovingVertically: true,
        movingSpeed: 150,
        movingAmplitude: 250,
        goingUpOrRight: false,
        removeOnKeyCardTriggerColor: Palette.orange,
      ),
    ]);
    await levelWorld.addArrow(Arrow(position: Vector2(800, 665.5), color: Palette.orange));
  }

  await levelWorld.addRooms([
    Room(position: Vector2(650, 400), size: Vector2(100, 100), doorPlacement: DoorPlacement.bottom, color: Palette.darkYellow),
    Room(position: Vector2(425, 600 - 3), size: Vector2(100, 100), doorPlacement: DoorPlacement.top, color: Palette.darkYellow),
  ]);

  await levelWorld.addWalls([
    Wall(position: Vector2(747, 503), orientation: WallOrientation.vertical, length: 150),
    Wall(position: Vector2(850, 0), orientation: WallOrientation.vertical, length: 653),
  ]);

  await levelWorld.addDoors([
    Door(position: Vector2(850, 653), orientation: WallOrientation.vertical, length: 47, thickness: 3, color: Palette.orange),
  ]);

  await levelWorld.addKeyCards([KeyCard(position: Vector2(800, 50), color: Palette.orange)]);

  await levelWorld.addCheckPoints([CheckPoint(position: Vector2(475, 650), id: 4), CheckPoint(position: Vector2(700, 450), id: 5)]);
}
