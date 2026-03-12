import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import '../../utils/palette.dart';
import '../game.dart';

class CheckPoint extends PositionComponent with HasGameReference<FGJ2026> {
  final int id;
  CheckPoint({required super.position, required this.id, super.key});

  final Paint circlePaint = Paint()
    ..color = Palette.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  final Paint textPaint = Paint()..color = Palette.white;

  bool isReached = false;

  @override
  void onLoad() {
    priority = 100;
    super.onLoad();
    anchor = Anchor.center;
    add(CircleComponent(anchor: Anchor.center, position: Vector2.zero(), radius: 12.5, paint: circlePaint));
    add(
      TextComponent(
        anchor: Anchor.center,
        text: '$id',
        textRenderer: TextPaint(style: TextStyle(fontSize: 20, color: textPaint.color)),
        position: Vector2(0, -2),
      ),
    );
  }

  void reached() {
    if (isReached) return;
    isReached = true;
    circlePaint.color = Palette.green;
    game.checkpointController.saveCheckpoint(id);
    game.audioController.playCheckpointReachedSound();
  }

  void markAsAlreadyReached() {
    isReached = true;
    circlePaint.color = Palette.green;
  }
}
