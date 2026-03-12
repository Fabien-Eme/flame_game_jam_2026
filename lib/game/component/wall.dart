import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import '../../utils/constants.dart';
import '../../utils/palette.dart';

class Wall extends PositionComponent {
  Wall({required super.position, required this.orientation, required this.length, this.thickness = 3, super.key});

  final WallOrientation orientation;
  final double length;
  final double thickness;
  final Paint paint = Paint()..color = Palette.white;

  @override
  void onLoad() {
    super.onLoad();

    add(
      RectangleComponent(
        position: Vector2.zero(),
        size: Vector2(orientation == WallOrientation.horizontal ? length : thickness, orientation == WallOrientation.vertical ? length : thickness),
        paint: paint,
        children: [RectangleHitbox(collisionType: CollisionType.passive)],
      ),
    );
  }
}
