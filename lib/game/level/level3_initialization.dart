import 'dart:math';
import 'package:flame/components.dart';
import '../../game/component/bb_camera.dart';
import '../../game/component/wall.dart';
import '../../game/level/level_world.dart';
import '../../utils/constants.dart';
import '../../utils/palette.dart';
import '../component/arrow.dart';
import '../component/check_point.dart';
import 'dart:ui';

Future<void> level3Initialization(LevelWorld levelWorld, List<Color> keyCardsOwned) async {
  if (!keyCardsOwned.contains(Palette.orange)) return;
  await levelWorld.addBBCameras([
    BBCamera(
      position: Vector2(1145, 108),
      maxDistance: 250,
      isRotating: true,
      startAngle: 3 * pi / 4,
      angleCovered: pi / 4,
      rotationAmplitude: pi,
      angleSpeed: 3,
    ),
    BBCamera(
      position: Vector2(1120, 545),
      maxDistance: 250,
      isRotating: true,
      startAngle: -3 * pi / 4,
      angleCovered: pi / 4,
      rotationAmplitude: pi,
      angleSpeed: 2.5,
    ),
    BBCamera(
      position: Vector2(1292, 425),
      maxDistance: 150,
      isRotating: true,
      startAngle: -pi,
      angleCovered: pi / 4,
      rotationAmplitude: pi,
      angleSpeed: 2.75,
    ),
    BBCamera(
      position: Vector2(1292, 275),
      maxDistance: 150,
      isRotating: true,
      startAngle: -pi,
      angleCovered: pi / 4,
      rotationAmplitude: pi,
      angleSpeed: 2.6,
    ),
  ]);

  await levelWorld.addArrow(Arrow(position: Vector2(1250, 332.5), color: Palette.orange));

  await levelWorld.addRooms([]);

  await levelWorld.addWalls([
    Wall(position: Vector2(1125, 550), orientation: WallOrientation.horizontal, length: 175),
    Wall(position: Vector2(1125, 550), orientation: WallOrientation.vertical, length: 150),
    Wall(position: Vector2(1150, 0), orientation: WallOrientation.vertical, length: 100),
    Wall(position: Vector2(1150, 100), orientation: WallOrientation.horizontal, length: 150),
    Wall(position: Vector2(850, 100), orientation: WallOrientation.horizontal, length: 300),
  ]);

  await levelWorld.addDoors([]);

  await levelWorld.addKeyCards(
    [

    ]);

  await levelWorld.addCheckPoints([CheckPoint(position: Vector2(875, 675), id: 6)]);
}
