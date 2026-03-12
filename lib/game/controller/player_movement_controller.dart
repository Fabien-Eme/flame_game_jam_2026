import 'package:flame/components.dart';
import 'package:flame_game_jam_2026/game/component/player.dart';

import '../game.dart';
import '../component/door.dart';
import '../component/key_card.dart';
import '../level/level_world.dart';

import '../level/level.dart';

class PlayerMovementController extends Component with HasWorldReference<LevelWorld>, HasGameReference<FGJ2026> {
  final PlayerComponent player;

  PlayerMovementController({required this.player});

  double runSpeed = 300;
  double walkSpeed = 150;
  double speed = 150;

  late final CameraComponent cameraComponent;

  @override
  void onLoad() {
    super.onLoad();
    cameraComponent = (world.parent! as Level).cameraComponent;
  }

  Vector2 direction = Vector2.zero();
  Vector2 movement = Vector2.zero();
  bool isMovingXPossible = false;
  bool isMovingYPossible = false;

  void movePlayer(Vector2 direction) {
    this.direction = direction;
  }

  void run() {
    speed = runSpeed;
  }

  void walk() {
    speed = walkSpeed;
  }

  @override
  void update(double dt) {
    if (world.isPaused) return;
    super.update(dt);

    /// Player movement and collision detection

    isMovingXPossible = true;
    isMovingYPossible = true;

    ///try to move the player horizontally
    movement = direction * speed * dt;
    player.position.x += movement.x;

    ///force colision check
    (world as HasCollisionDetection).collisionDetection.run();

    ///if the player is colliding, undo the horizontal movement
    if (player.hitbox.isColliding) {
      player.position.x -= movement.x;
      isMovingXPossible = false;
    }

    ///try to move the player vertically
    player.position.y += movement.y;

    ///force colision check
    (world as HasCollisionDetection).collisionDetection.run();

    ///if the player is colliding, undo the vertical movement
    if (player.hitbox.isColliding) {
      player.position.y -= movement.y;
      isMovingYPossible = false;
    }

    if (isMovingXPossible) {
      if (isMovingYPossible) {
        cameraComponent.viewfinder.position += movement;
      } else {
        cameraComponent.viewfinder.position += Vector2(movement.x, 0);
      }
    } else if (isMovingYPossible) {
      cameraComponent.viewfinder.position += Vector2(0, movement.y);
    }

    /// Doors
    refreshNearestDoor();
    refreshSelectedDoor();

    refreshNearestKeyCard();
    refreshSelectedKeyCard();

    checkIfCheckPointReached();
  }

  ///
  ///
  ///
  ///
  /// Door management

  Door? nearestDoor;
  Door? selectedDoor;

  double nearestDistance = double.infinity;
  double maxDoorDistance = 65;

  void refreshNearestDoor() {
    nearestDistance = double.infinity;
    nearestDoor = null;
    for (final Door door in world.doors) {
      final distance = door.centerPosition.distanceTo(player.position);
      if (distance < nearestDistance && distance < maxDoorDistance) {
        nearestDistance = distance;
        nearestDoor = door;
      }
    }
  }

  void refreshSelectedDoor() {
    for (final door in world.doors) {
      if (nearestDoor == door) {
        if (!door.isSelected) {
          if (game.keycardController.keyCardsOwned.contains(door.color)) {
            door.select();
            selectedDoor = door;
          }
        }
      } else {
        if (door.isSelected) {
          door.deselect();
        }
      }
    }
  }

  /// Key card management

  KeyCard? nearestKeyCard;
  KeyCard? selectedKeyCard;

  double nearestKeyCardDistance = double.infinity;
  double maxKeyCardDistance = 20;

  void refreshNearestKeyCard() {
    nearestKeyCardDistance = double.infinity;
    nearestKeyCard = null;
    for (final keyCard in world.keyCards) {
      final distance = keyCard.position.distanceTo(player.position);

      if (distance < nearestKeyCardDistance && distance < maxKeyCardDistance) {
        nearestKeyCardDistance = distance;
        nearestKeyCard = keyCard;
      }
    }
  }

  void refreshSelectedKeyCard() {
    for (final keyCard in world.keyCards) {
      if (keyCard.isSelected) {
        keyCard.deselect();
      }
    }
    if (nearestKeyCard != null) {
      nearestKeyCard!.select();
      selectedKeyCard = nearestKeyCard;
    }
  }

  void checkIfCheckPointReached() {
    for (final checkPoint in world.checkPoints) {
      if (checkPoint.position.distanceTo(player.position) < 20) {
        checkPoint.reached();
      }
    }
  }
}
