import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

import '../component/bb_camera.dart';
import '../game.dart';

class RayController extends Component with HasGameReference<FGJ2026>, HasWorldReference {
  List<BBCamera> bbCameras = [];

  final paintWhite = Paint()
    ..color = Color.fromARGB(255, 253, 252, 175)
    ..strokeWidth = 2.0;

  final paintRed = Paint()
    ..color = Color.fromARGB(255, 250, 40, 40)
    ..strokeWidth = 2.0;

  static const numberOfRays = 100;
  final List<Ray2> rays = [];
  final List<RaycastResult<ShapeHitbox>> results = [];
  final Map<int, List<RaycastResult<ShapeHitbox>>> allResults = {};

  @override
  void onLoad() {
    super.onLoad();
  }

  void addBBCamera(BBCamera bbcCamera) {
    bbCameras.add(bbcCamera);
    allResults[bbcCamera.id] = [];
  }

  bool detected = false;

  @override
  void update(double dt) {
    super.update(dt);

    for (final bbcCamera in bbCameras) {
      allResults[bbcCamera.id]!.clear();

      (world as HasCollisionDetection).collisionDetection.raycastAll(
        startAngle: bbcCamera.startAngle,
        sweepAngle: pi / 4,
        bbcCamera.position,
        numberOfRays: numberOfRays,
        rays: rays,
        out: allResults[bbcCamera.id],
      );

      detected = false;
      for (final result in allResults[bbcCamera.id]!) {
        if (result.hitbox is CircleHitbox) {
          if (result.distance != null && result.distance! < bbcCamera.maxDistance) {
            detected = true;
            break;
          }
        }
      }
      if (detected) {
        bbcCamera.doesSeePlayer = true;
      } else {
        bbcCamera.doesSeePlayer = false;
      }
    }
  }

  void renderAllRays(Canvas canvas) {
    for (final bbcCamera in bbCameras) {
      if (allResults[bbcCamera.id] != null && allResults[bbcCamera.id]!.isNotEmpty) {
        if (bbcCamera.doesSeePlayer) {
          renderResult(canvas, bbcCamera.position, allResults[bbcCamera.id]!, paintRed, bbcCamera.maxDistance);
        } else {
          renderResult(canvas, bbcCamera.position, allResults[bbcCamera.id]!, paintWhite, bbcCamera.maxDistance);
        }
      }
    }
  }

  void renderResult(Canvas canvas, Vector2 origin, List<RaycastResult<ShapeHitbox>> results, Paint paint, double maxDistance) {
    final originOffset = origin.toOffset();

    for (final result in results) {
      if (result.intersectionPoint == null || !result.isActive) {
        continue;
      }

      final delta = result.intersectionPoint!.clone()..sub(origin);

      if (delta.length > maxDistance) {
        delta.scaleTo(maxDistance);
      }

      final endPoint = origin.clone()..add(delta);

      canvas.drawLine(originOffset, endPoint.toOffset(), paint);
    }
  }
}
