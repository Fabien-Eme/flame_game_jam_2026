import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/geometry.dart';

import '../../utils/palette.dart';
import '../controller/custom_gamepad_controller.dart';
import '../game.dart';
import '../snackbar/snackbar_controller.dart';
import 'level.dart';
import '../component/player.dart';

class LevelWorld1 extends World
    with HasGameReference<FGJ2026>, HasCollisionDetection, TapCallbacks {
  late final SnackbarController snackBarController;

  Ray2? ray;
  Ray2? reflection;

  Vector2? origin;
  Vector2? tapOrigin;
  bool isOriginCasted = false;
  bool isTapOriginCasted = false;
  final paint = Paint()
    ..color = Color.fromARGB(98, 253, 252, 175)
    ..strokeWidth = 2.0;
  final tapPaint = Paint()
    ..color = Palette.red
    ..strokeWidth = 1.0;

  static const numberOfRays = 100;
  final List<Ray2> rays = [];
  final List<Ray2> tapRays = [];
  final List<RaycastResult<ShapeHitbox>> results = [];
  final List<RaycastResult<ShapeHitbox>> tapResults = [];

  late final PlayerComponent player;

  @override
  FutureOr<void> onLoad() async {
    await parent!.mounted;

    await addAll([snackBarController = SnackbarController()]);

    final paint = Paint()
      ..color = Palette.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    add(ScreenHitbox());

    add(
      RectangleComponent(
        position: Vector2.all(100),
        anchor: Anchor.center,
        size: Vector2.all(100),
        paint: paint,
        children: [RectangleHitbox()],
      ),
    );

    add(player = PlayerComponent(position: Vector2.zero()));
    add(CustomGamepadController(movePlayer: movePlayer));

    return super.onLoad();
  }

  Vector2 direction = Vector2.zero();

  void movePlayer(Vector2 direction) {
    this.direction = direction;
  }

  double startAngle = 0;

  @override
  void update(double dt) {
    startAngle += pi / 4 * dt;

    if (player.isLoaded) {
      final movement = direction * 250 * dt;

      player.position.x += movement.x;
      player.position.y += movement.y;

      super.update(dt);

      if (player.hitbox.isColliding) {
        player.position.x -= movement.x * 1.1;
      }

      if (player.hitbox.isColliding) {
        player.position.y -= movement.y * 1.1;
      }
    }

    final origin =
        (parent as Level).cameraComponent.viewport.globalToLocal(
          game.mousePosition,
        ) -
        Vector2(FGJ2026.gameWidth / 2, FGJ2026.gameHeight / 2);
    isOriginCasted = origin == this.origin;
    this.origin = origin;

    //if (!isOriginCasted || direction != Vector2.zero()) {
    collisionDetection.raycastAll(
      startAngle: startAngle,
      sweepAngle: pi / 4,
      origin,
      numberOfRays: numberOfRays,
      rays: rays,
      out: results,
    );
    isOriginCasted = true;
    //}
    if (tapOrigin != null && !isTapOriginCasted) {
      collisionDetection.raycastAll(
        tapOrigin!,
        numberOfRays: numberOfRays,
        rays: tapRays,
        out: tapResults,
      );
      isTapOriginCasted = true;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (origin != null) {
      renderResult(canvas, origin!, results, paint, 250);
    }
    if (tapOrigin != null) {
      renderResult(canvas, tapOrigin!, tapResults, tapPaint, 250);
    }
  }

  void renderResult(
    Canvas canvas,
    Vector2 origin,
    List<RaycastResult<ShapeHitbox>> results,
    Paint paint,
    double maxDistance,
  ) {
    final originOffset = origin.toOffset();
    for (final result in results) {
      if (!result.isActive || result.intersectionPoint == null) {
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
