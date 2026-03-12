import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';

import '../game/level/level.dart';
import '../game/game.dart';

class DebugPointer extends PositionComponent with HasGameReference<FGJ2026> {
  DebugPointer({required super.position, super.key});

  @override
  void onLoad() {
    super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    final precision = debugCoordinatesPrecision;
    canvas.drawRect(size.toRect(), debugPaint);
    // draw small cross at the anchor point
    final p0 = -transform.offset;

    canvas.drawLine(Offset(p0.x, p0.y - 5), Offset(p0.x, p0.y + 5), debugPaint);
    canvas.drawLine(Offset(p0.x - 5, p0.y), Offset(p0.x + 5, p0.y), debugPaint);
    if (precision != null) {
      // print coordinates at the center
      final p1 = absolutePositionOfAnchor(Anchor.center);
      final x1str = p1.x.toStringAsFixed(precision);
      final y1str = p1.y.toStringAsFixed(precision);

      final zoom = (parent as FixedResolutionViewport).camera.viewfinder.zoom;
      final x = (parent as FixedResolutionViewport).camera.viewfinder.position.x + FGJ2026.gameWidth / 2 / zoom;
      final y = (parent as FixedResolutionViewport).camera.viewfinder.position.y + FGJ2026.gameHeight / 2 / zoom;
      final xAdjusted = x + (p1.x - FGJ2026.gameWidth / 2) / zoom;
      final yAdjusted = y + (p1.y - FGJ2026.gameHeight / 2) / zoom;

      debugTextPaint.render(canvas, 'x:${xAdjusted.toStringAsFixed(precision)} y:${yAdjusted.toStringAsFixed(precision)}', Vector2(0, -30 / 1));
    }
  }
}
