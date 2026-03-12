import 'dart:ui';

import 'package:flame/components.dart';

import '../../utils/constants.dart';
import 'door.dart';
import 'wall.dart';

enum DoorPlacement { left, right, top, bottom, none }

class Room extends PositionComponent {
  final double wallThickness;
  final DoorPlacement doorPlacement;
  final Color color;
  Room({
    required super.position,
    required super.size,
    this.wallThickness = 3.0,
    this.doorPlacement = DoorPlacement.none,
    required this.color,
    super.key,
  });

  Door? door;

  @override
  void onLoad() {
    super.onLoad();
    priority = 100;

    addWall(WallOrientation.horizontal, Vector2(0, 0), size.x, wallThickness, doorPlacement == DoorPlacement.top);
    addWall(WallOrientation.horizontal, Vector2(0, size.y), size.x, wallThickness, doorPlacement == DoorPlacement.bottom);
    addWall(WallOrientation.vertical, Vector2(0, 0), size.y, wallThickness, doorPlacement == DoorPlacement.left);
    addWall(WallOrientation.vertical, Vector2(size.x - wallThickness, 0), size.y, wallThickness, doorPlacement == DoorPlacement.right);
  }

  void addWall(WallOrientation orientation, Vector2 position, double length, double thickness, bool hasDoor) {
    if (hasDoor) {
      if (orientation == WallOrientation.horizontal) {
        add(Wall(position: position, orientation: orientation, length: (length - 50) / 2, thickness: thickness));
        add(
          door = Door(position: position + Vector2((length - 50) / 2, 0), orientation: orientation, length: 50, thickness: thickness, color: color),
        );
        add(Wall(position: position + Vector2((length - 50) / 2 + 50, 0), orientation: orientation, length: (length - 50) / 2, thickness: thickness));
      } else {
        add(Wall(position: position, orientation: orientation, length: (length - 50) / 2, thickness: thickness));
        add(
          door = Door(position: position + Vector2(0, (length - 50) / 2), orientation: orientation, length: 50, thickness: thickness, color: color),
        );
        add(Wall(position: position + Vector2(0, (length - 50) / 2 + 50), orientation: orientation, length: (length - 50) / 2, thickness: thickness));
      }
    } else {
      add(Wall(position: position, orientation: orientation, length: length, thickness: thickness));
    }
  }
}
