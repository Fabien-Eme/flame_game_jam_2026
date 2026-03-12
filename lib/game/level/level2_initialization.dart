import 'dart:math';
import 'package:flame/components.dart';
import '../../game/component/bb_camera.dart';
import '../../game/component/room.dart';
import '../../game/component/wall.dart';
import '../../game/level/level_world.dart';
import '../../game/game.dart';
import '../../utils/constants.dart';
import '../../utils/palette.dart';
import '../../game/component/key_card.dart';
import '../component/check_point.dart';
import '../component/door.dart';
import 'dart:ui';

Future<void> level2Initialization(LevelWorld levelWorld, List<Color> keyCardsOwned) async {
  if (!keyCardsOwned.contains(Palette.darkYellow)) return;
  await levelWorld.addBBCameras([
    BBCamera(position: Vector2(875, 230), maxDistance: 250, isRotating: true, startAngle: pi / 4, rotationAmplitude: pi / 4, angleSpeed: 0.6),
  ]);

  await levelWorld.addRooms([]);

  await levelWorld.addWalls([]);

  await levelWorld.addDoors([]);

  await levelWorld.addKeyCards([]);

  await levelWorld.addCheckPoints([]);
}
