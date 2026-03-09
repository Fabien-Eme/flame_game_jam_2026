import 'package:flame/components.dart';

import '../../utils/constants.dart';
import 'door.dart';
import 'wall.dart';

class Room extends PositionComponent {
  Room({required super.position, required super.size, super.key});

  Door? door;

  @override
  void onLoad() {
    super.onLoad();

    double thickness = 5.0;
    add(Wall(position: Vector2.zero(), orientation: WallOrientation.horizontal, length: 50, thickness: thickness));
    add(door = Door(position: Vector2(50, 0), orientation: WallOrientation.horizontal, length: 50, thickness: thickness));
    add(Wall(position: Vector2(100, 0), orientation: WallOrientation.horizontal, length: size.x - 100, thickness: thickness));
    add(Wall(position: Vector2(0, size.y - thickness), orientation: WallOrientation.horizontal, length: size.x, thickness: thickness));
    add(Wall(position: Vector2.zero(), orientation: WallOrientation.vertical, length: size.y, thickness: thickness));
    add(Wall(position: Vector2(size.x - thickness, 0), orientation: WallOrientation.vertical, length: size.y, thickness: thickness));
  }
}
