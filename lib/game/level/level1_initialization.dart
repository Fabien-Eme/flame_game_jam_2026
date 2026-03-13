import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import '../../game/component/bb_camera.dart';
import '../../game/component/room.dart';
import '../../game/component/wall.dart';
import '../../game/level/level_world.dart';
import '../../game/game.dart';
import '../../utils/constants.dart';
import '../../utils/palette.dart';
import '../../game/component/key_card.dart';
import '../component/arrow.dart';
import '../component/check_point.dart';
import '../component/door.dart';

Future<void> level1Initialization(LevelWorld levelWorld, List<Color> keyCardsOwned) async {
  if (!keyCardsOwned.contains(Palette.darkYellow)) {
    await levelWorld.addBBCameras([
      BBCamera(
        position: Vector2(5, 375),
        maxDistance: 250,
        isRotating: true,
        startAngle: pi / 4,
        rotationAmplitude: pi / 4,
        angleSpeed: (keyCardsOwned.contains(Palette.red)) ? 2 : 0.6,
        removeOnKeyCardTriggerColor: Palette.darkYellow,
        keyCardColorTrigger: Palette.red,
        keyCardTriggerFunction: (BBCamera camera) => camera.angleSpeed = 2,
      ),
      BBCamera(
        position: Vector2(100 + 5, 200),
        maxDistance: 150,
        isRotating: false,
        startAngle: pi / 8,
        removeOnKeyCardTriggerColor: Palette.darkYellow,
      ),
      BBCamera(
        position: Vector2(490, 390),
        maxDistance: 150,
        isRotating: false,
        startAngle: -pi / 2 - pi / 8,
        removeOnKeyCardTriggerColor: Palette.darkYellow,
      ),
      BBCamera(
        position: Vector2(300 + 5, 150),
        maxDistance: 100,
        isRotating: true,
        startAngle: -pi / 8,
        rotationAmplitude: pi / 4,
        angleSpeed: 0.6,
        isMoving: true,
        isMovingVertically: true,
        movingSpeed: 100,
        movingAmplitude: 200,
        goingUpOrRight: false,
        removeOnKeyCardTriggerColor: Palette.darkYellow,
      ),
      BBCamera(
        position: Vector2(635, 5),
        maxDistance: 250,
        isRotating: true,
        startAngle: 3 * pi / 4,
        rotationAmplitude: pi / 3,
        angleSpeed: 0.75,
        removeOnKeyCardTriggerColor: Palette.darkYellow,
      ),

      BBCamera(
        position: Vector2(675, 325),
        maxDistance: 50,
        isRotating: false,
        startAngle: 0,
        rotationAmplitude: 2 * pi,
        movingAmplitude: 100,
        keyCardColorTrigger: Palette.red,
        keyCardTriggerFunction: (BBCamera camera) => camera.isMoving = true,
        isMoving: (keyCardsOwned.contains(Palette.red)) ? true : false,
        removeOnKeyCardTriggerColor: Palette.darkYellow,
      ),
    ]);

    await levelWorld.addArrow(Arrow(position: Vector2(375, 462.5), color: Palette.darkYellow));
  }

  await levelWorld.addRooms([
    Room(
      position: Vector2(0, 0),
      size: Vector2(FGJ2026.gameWidth, FGJ2026.gameHeight - 3),
      doorPlacement: DoorPlacement.right,
      color: Palette.orange,
    ),
    Room(position: Vector2(0, 0), size: Vector2(100, 200), doorPlacement: DoorPlacement.bottom, color: Palette.lightBlue),
    Room(position: Vector2(100 - 3, 0), size: Vector2(200, 100), doorPlacement: DoorPlacement.right, color: Palette.lightBlue),
    Room(position: Vector2(650, 0), size: Vector2(100, 150), doorPlacement: DoorPlacement.bottom, color: Palette.lightBlue),
  ]);

  await levelWorld.addWalls([
    Wall(position: Vector2(100 - 3, 0), orientation: WallOrientation.vertical, length: 350),
    Wall(position: Vector2(100 - 3, 500), orientation: WallOrientation.horizontal, length: 25),
    Wall(position: Vector2(100 - 3, 500), orientation: WallOrientation.vertical, length: 200),
    Wall(position: Vector2(200, 400), orientation: WallOrientation.horizontal, length: 150),
    Wall(position: Vector2(400, 400), orientation: WallOrientation.horizontal, length: 350),
    Wall(position: Vector2(200, 400), orientation: WallOrientation.vertical, length: 50),
    Wall(position: Vector2(500, 40), orientation: WallOrientation.vertical, length: 360),
    Wall(position: Vector2(750 - 3, 50), orientation: WallOrientation.vertical, length: 350),
    Wall(position: Vector2(425, 403), orientation: WallOrientation.vertical, length: 47),
    Wall(position: Vector2(425, 500), orientation: WallOrientation.vertical, length: 200),
  ]);

  await levelWorld.addDoors([
    Door(position: Vector2(350, 400), orientation: WallOrientation.horizontal, length: 50, thickness: 3, color: Palette.red),
    Door(position: Vector2(425, 450), orientation: WallOrientation.vertical, length: 50, thickness: 3, color: Palette.darkYellow),
  ]);
  await levelWorld.addKeyCards([
    KeyCard(position: Vector2(50, 20), color: Palette.lightBlue),
    KeyCard(position: Vector2(700, 70), color: Palette.red),
    KeyCard(position: Vector2(50, 650), color: Palette.darkYellow),
  ]);

  await levelWorld.addCheckPoints([
    CheckPoint(position: Vector2(150, 50), id: 1),
    CheckPoint(position: Vector2(700, 35), id: 2),
    CheckPoint(position: Vector2(230, 430), id: 3),
  ]);
}
