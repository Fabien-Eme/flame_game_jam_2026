import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

import '../component/bb_camera.dart';
import '../game.dart';
import '../level/level_world.dart';

class RayController extends Component with HasGameReference<FGJ2026>, HasWorldReference<LevelWorld> {
  RayController({required super.priority, super.key});

  List<BBCamera> bbCameras = [];

  final paintWhite = Paint()
    ..color = Color.fromARGB(255, 253, 252, 175)
    ..strokeWidth = 4.0;

  final paintRed = Paint()
    ..color = Color.fromARGB(255, 250, 40, 40)
    ..strokeWidth = 4.0;

  final List<Ray2> rays = [];
  final List<RaycastResult<ShapeHitbox>> results = [];
  final Map<int, List<RaycastResult<ShapeHitbox>>> allResults = {};

  @override
  void onLoad() {
    super.onLoad();
  }

  void addBBCamera(BBCamera bbCamera) {
    bbCameras.add(bbCamera);
    allResults[bbCamera.id] = [];
  }

  void removeBBCamera(BBCamera bbCamera) {
    bbCameras.remove(bbCamera);
    allResults.remove(bbCamera.id);
  }

  bool detected = false;
  bool busted = false;

  @override
  void update(double dt) {
    if (world.isPaused) return;
    if (busted) world.bustedController.busted();
    for (final bbCamera in bbCameras) {
      allResults[bbCamera.id]!.clear();

      world.collisionDetection.raycastAll(
        startAngle: bbCamera.startAngle,
        sweepAngle: bbCamera.angleCovered!,
        bbCamera.position,
        numberOfRays: bbCamera.numberOfRays,
        rays: rays,
        out: allResults[bbCamera.id],
      );

      detected = false;

      if (bbCamera.position.distanceTo(world.player.position) < bbCamera.maxDistance + 12.5) {
        for (final result in allResults[bbCamera.id]!) {
          if (result.hitbox is CircleHitbox) {
            if (result.distance != null && result.distance! < bbCamera.maxDistance + 12.5) {
              detected = true;
              busted = true;
              break;
            }
          }
        }
      }
      if (detected) {
        bbCamera.doesSeePlayer = true;
      } else {
        bbCamera.doesSeePlayer = false;
      }
    }
  }

  void renderAllRays(Canvas canvas) {
    for (final bbCamera in bbCameras) {
      if (allResults[bbCamera.id] != null && allResults[bbCamera.id]!.isNotEmpty) {
        if (bbCamera.doesSeePlayer) {
          renderResult(canvas, bbCamera.position, allResults[bbCamera.id]!, paintRed, bbCamera.maxDistance);
        } else {
          renderResult(canvas, bbCamera.position, allResults[bbCamera.id]!, paintWhite, bbCamera.maxDistance);
        }
      }
    }
  }

  void renderResult(Canvas canvas, Vector2 origin, List<RaycastResult<ShapeHitbox>> results, Paint paint, double maxDistance) {
    final originOffset = origin.toOffset();
    Vector2 delta = Vector2.zero();
    Vector2 endPoint = Vector2.zero();

    for (final result in results) {
      if (result.intersectionPoint == null || !result.isActive) {
        continue;
      }

      delta = result.intersectionPoint! - origin;

      if (delta.length2 > maxDistance * maxDistance) {
        delta.scaleTo(maxDistance);
      }

      endPoint = origin + delta;

      canvas.drawLine(originOffset, endPoint.toOffset(), paint);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    renderAllRays(canvas);
  }
}
