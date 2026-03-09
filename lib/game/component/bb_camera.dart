import 'dart:math';

import 'package:flame/components.dart';

class BBCamera extends PositionComponent {
  final int id;
  final double maxDistance;
  double startAngle;
  double angleSpeed;

  BBCamera({required super.position, required this.id, required this.maxDistance, this.startAngle = 0, this.angleSpeed = 1, super.key});

  bool doesSeePlayer = false;

  @override
  void onLoad() {
    super.onLoad();
  }

  @override
  void update(double dt) {
    startAngle += pi / 4 * angleSpeed * dt;
    super.update(dt);
  }
}
