import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_game_jam_2026/game/component/arrow.dart';
import 'package:flame_game_jam_2026/game/component/bb_camera.dart';
import 'package:flame_game_jam_2026/game/component/key_card_hud.dart';
import 'package:flame_game_jam_2026/game/controller/player_movement_controller.dart';

import '../../utils/palette.dart';
import '../component/check_point.dart';
import '../component/chronometer.dart';
import '../component/explanations.dart';
import '../component/key_card.dart';
import '../controller/busted_controller.dart';
import '../component/room.dart';
import '../component/wall.dart';
import '../controller/ray_controller.dart';
import '../controller/victory_controller.dart';
import '../game.dart';
import '../component/player.dart';
import '../component/door.dart';
import '../menu/menu_in_game.dart';
import 'level.dart';
import 'level1_initialization.dart';
import 'level2_initialization.dart';
import 'level3_initialization.dart';
import '../controller/welcome_controller.dart';

class LevelWorld extends World with HasGameReference<FGJ2026>, HasCollisionDetection {
  LevelWorld({super.key});

  late final PlayerMovementController playerMovementController;

  List<Room> rooms = [];
  List<Door> doors = [];
  List<BBCamera> bbCameras = [];
  List<KeyCard> keyCards = [];
  List<CheckPoint> checkPoints = [];
  List<Arrow> arrows = [];

  late final KeyCardHUD keyCardHUD;

  late final PlayerComponent player;

  late final BustedController bustedController;
  late final VictoryController victoryController;
  late final WelcomeController welcomeController;
  late final RayController rayController;

  final Vector2 initialPlayerPosition = Vector2(50, 100);

  bool isPaused = false;

  @override
  FutureOr<void> onLoad() async {
    await parent!.mounted;

    add(
      RectangleComponent.fromRect(
        Rect.fromLTWH(0, 0, FGJ2026.gameWidth, FGJ2026.gameHeight),
        paint: Paint()..color = Palette.veryDarkGrey,
        priority: -1000,
      ),
    );

    await add(welcomeController = WelcomeController());
    await add(bustedController = BustedController());
    await add(victoryController = VictoryController());
    await add(player = PlayerComponent(position: Vector2(-1000, -1000)));

    await add(playerMovementController = PlayerMovementController(player: player));
    await add(rayController = RayController(priority: -100));

    game.universalGamepadController.levelWorld = this;
    game.keyboardController.levelWorld = this;

    final keyCardsOwned = await game.keycardController.getKeyCardsInMemory();

    await level1Initialization(this, keyCardsOwned);
    await level2Initialization(this, keyCardsOwned);
    await level3Initialization(this, keyCardsOwned);

    await add(keyCardHUD = KeyCardHUD(position: Vector2(FGJ2026.gameWidth - 150, FGJ2026.gameHeight - 125)));
    await add(MenuInGame(position: Vector2(FGJ2026.gameWidth - 125, 25)));

    if ((parent! as Level).speedRunMode) {
      await add(Chronometer(position: Vector2(FGJ2026.gameWidth / 2 - 75, FGJ2026.gameHeight / 2 + 20)));
    }

    game.keycardController.removeKeyCardAlreadyCollected(this);
    game.checkpointController.markCheckpointAlreadyReached(this);

    if (game.checkpointController.currentCheckpoint == 0 || (parent! as Level).speedRunMode || (parent! as Level).newGame) {
      player.position = initialPlayerPosition;
    } else {
      player.position = game.checkpointController.getCurrentCheckpointPosition(checkPoints);
      await game.keycardController.getKeyCardsInMemory(keyCardHUD);
    }

    await add(Explanations(position: Vector2(875, 7.5), inGame: true));

    if ((parent! as Level).newGame) {
      welcomeController.welcome();
    }

    return super.onLoad();
  }

  Future<void> addBBCamera(BBCamera bbCamera) async {
    bbCameras.add(bbCamera);
    await add(bbCamera);
    rayController.addBBCamera(bbCamera);
  }

  Future<void> addBBCameras(List<BBCamera> bbCameras) async {
    for (final bbCamera in bbCameras) {
      await addBBCamera(bbCamera);
    }
  }

  Future<void> addRoom(Room room) async {
    rooms.add(room);
    await add(room);
    if (room.door != null) {
      doors.add(room.door!);
    }
  }

  Future<void> addRooms(List<Room> rooms) async {
    for (final room in rooms) {
      await addRoom(room);
    }
  }

  Future<void> addWall(Wall wall) async {
    await add(wall);
  }

  Future<void> addWalls(List<Wall> walls) async {
    for (final wall in walls) {
      await addWall(wall);
    }
  }

  Future<void> addDoor(Door door) async {
    await add(door);
    doors.add(door);
  }

  Future<void> addDoors(List<Door> doors) async {
    for (final door in doors) {
      await addDoor(door);
    }
  }

  Future<void> addKeyCard(KeyCard keyCard) async {
    await add(keyCard);
    keyCards.add(keyCard);
  }

  Future<void> addKeyCards(List<KeyCard> keyCards) async {
    for (final keyCard in keyCards) {
      await addKeyCard(keyCard);
    }
  }

  Future<void> addCheckPoint(CheckPoint checkPoint) async {
    if ((parent! as Level).speedRunMode) return;
    await add(checkPoint);
    checkPoints.add(checkPoint);
  }

  Future<void> addCheckPoints(List<CheckPoint> checkPoints) async {
    for (final checkPoint in checkPoints) {
      await addCheckPoint(checkPoint);
    }
  }

  Future<void> addArrow(Arrow arrow) async {
    await add(arrow);
    arrows.add(arrow);
  }
}
