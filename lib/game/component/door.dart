import 'dart:math' show pi;
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../utils/constants.dart';
import '../../utils/palette.dart';

class Door extends PositionComponent {
  Door({required super.position, required this.orientation, required this.length, required this.thickness, super.key});

  final WallOrientation orientation;
  final double length;
  final double thickness;
  final Paint paint = Paint()..color = Palette.blue;

  bool isOpen = false;
  bool isOpening = false;
  bool isClosing = false;

  bool isSelected = false;

  Vector2 centerPosition = Vector2.zero();

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

    computeCenter();
  }

  void computeCenter() {
    Vector2 offsetDueToStateAndOrientation = Vector2(0, 0);
    if (orientation == WallOrientation.horizontal) {
      if (!isOpen) {
        offsetDueToStateAndOrientation.x = length / 2;
      } else {
        offsetDueToStateAndOrientation.x = 0;
        offsetDueToStateAndOrientation.y = length / 2;
      }
    }
    if (orientation == WallOrientation.vertical) {
      if (!isOpen) {
        offsetDueToStateAndOrientation.y = length / 2;
      } else {
        offsetDueToStateAndOrientation.y = 0;
        offsetDueToStateAndOrientation.x = length / 2;
      }
    }

    centerPosition = (parent as PositionComponent).position + position + offsetDueToStateAndOrientation;
  }

  void open() {
    if (!isOpen) {
      isOpening = true;
    }
  }

  void close() {
    if (isOpen) {
      isClosing = true;
    }
  }

  void toggleState() {
    if (isOpen) {
      close();
    } else {
      open();
    }
  }

  void toggleSelection() {
    if (isSelected) {
      deselect();
    } else {
      select();
    }
  }

  void select() {
    isSelected = true;
    paint.color = Palette.green;
  }

  void deselect() {
    isSelected = false;
    paint.color = Palette.blue;
  }

  @override
  void update(double dt) {
    if (isOpening) {
      angle += pi / 2 * 2 * dt;
      if (angle >= pi / 2) {
        angle = pi / 2;
        isOpening = false;
        isOpen = true;
        computeCenter();
      }
    }
    if (isClosing) {
      angle -= pi / 2 * 2 * dt;
      if (angle <= 0) {
        angle = 0;
        isClosing = false;
        isOpen = false;
        computeCenter();
      }
    }
    super.update(dt);
  }
}
