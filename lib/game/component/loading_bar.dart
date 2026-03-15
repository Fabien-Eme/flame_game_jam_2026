import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import '../../utils/palette.dart';
import 'dart:async';

class LoadingBar extends PositionComponent {
  LoadingBar({required super.position, required this.duration, required super.size, this.delay = 0, super.key});

  final double duration;
  double delay;
  RectangleComponent loadingBarFill = RectangleComponent();
  RectangleComponent loadingBarStroke = RectangleComponent();

  @override
  FutureOr<void> onLoad() async {
    add(
      loadingBarFill = RectangleComponent(
        anchor: Anchor.centerLeft,
        position: Vector2(-100, 100),
        size: Vector2(0, size.y),
        paint: Paint()..color = Palette.white,
      ),
    );

    add(
      loadingBarStroke = RectangleComponent(
        anchor: Anchor.center,
        size: size,
        position: Vector2(0, 100),
        paint: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Palette.white,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (delay > 0) {
      delay = delay - dt;
      return;
    }
    if (loadingBarFill.size.x < size.x) {
      loadingBarFill.size = Vector2(loadingBarFill.size.x + size.x / duration * dt, size.y);
    } else {
      loadingBarFill.size = Vector2(size.x, size.y);
    }
  }
}
