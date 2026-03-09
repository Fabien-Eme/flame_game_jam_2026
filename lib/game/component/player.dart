import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../../utils/palette.dart';

class PlayerComponent extends PositionComponent {
  PlayerComponent({required super.position, super.key});

  late final CircleHitbox hitbox;

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;

    final paint = Paint()
      ..color = Palette.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    hitbox = CircleHitbox();

    add(CircleComponent(position: Vector2.zero(), anchor: Anchor.center, radius: 12.5, paint: paint, children: [hitbox]));
    return super.onLoad();
  }
}
