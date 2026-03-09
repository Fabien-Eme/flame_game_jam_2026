import 'package:flame/components.dart';
import 'package:flame_game_jam_2026/game/component/player.dart';

import '../component/door.dart';
import '../level/level_world.dart';

class PlayerMovementController extends Component with HasWorldReference {
  final PlayerComponent player;

  PlayerMovementController({required this.player});

  @override
  void onLoad() {
    super.onLoad();
  }

  Vector2 direction = Vector2.zero();

  void movePlayer(Vector2 direction) {
    this.direction = direction;
  }

  Vector2 tmpPosition = Vector2.zero();

  @override
  void update(double dt) {
    super.update(dt);

    if (player.hitbox.isColliding) {
      player.position.setValues(tmpPosition.x, tmpPosition.y);
    }

    tmpPosition.setValues(player.position.x, player.position.y);

    final movement = direction * 250 * dt;

    player.position.x += movement.x;
    player.position.y += movement.y;

    refreshNearestDoor();
    refreshSelectedDoor();
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
    for (final Door door in (world as LevelWorld).doors) {
      final distance = door.centerPosition.distanceTo(player.position);
      if (distance < nearestDistance && distance < maxDoorDistance) {
        nearestDistance = distance;
        nearestDoor = door;
      }
    }
  }

  void refreshSelectedDoor() {
    for (final door in (world as LevelWorld).doors) {
      if (nearestDoor == door) {
        if (!door.isSelected) {
          door.select();
          selectedDoor = door;
        }
      } else {
        if (door.isSelected) {
          door.deselect();
        }
      }
    }
  }
}
