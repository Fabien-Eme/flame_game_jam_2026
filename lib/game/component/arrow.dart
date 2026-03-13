import 'dart:ui';

import 'package:flame/components.dart';

class Arrow extends PositionComponent {
  final Color color;

  Arrow({required super.position, required this.color, super.key});

  final List<Vector2> vertices = [Vector2(0, 0), Vector2(20, 15), Vector2(0, 30)];

  @override
  void onLoad() {
    priority = -101;
    anchor = Anchor.center;
    add(RectangleComponent(position: Vector2(0, 10), size: Vector2(25, 10), paint: Paint()..color = color));
    add(PolygonComponent(vertices, position: Vector2(20, 0), paint: Paint()..color = color));

    super.onLoad();
  }
}
