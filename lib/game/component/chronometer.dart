import 'package:flame/components.dart';
import 'package:flutter/rendering.dart';
import '../level/level_world.dart';
import '../../utils/palette.dart';

class Chronometer extends PositionComponent with HasWorldReference<LevelWorld> {
  Chronometer({required super.position, super.key});

  double timeElapsed = 0;

  TextComponent timeText = TextComponent();

  @override
  void onLoad() {
    anchor = Anchor.center;
    priority = 999;

    add(
      RectangleComponent(
        anchor: Anchor.center,
        position: Vector2.zero(),
        size: Vector2(125, 50),
        paint: Paint()..color = Palette.whiteVeryTransparent,
      ),
    );

    // make time look like 00:00:00

    add(
      timeText = TextComponent(
        anchor: Anchor.center,
        text: '00:00:000',
        textRenderer: TextPaint(style: TextStyle(fontSize: 20, color: Palette.white)),
      ),
    );
    super.onLoad();
  }

  void updateTime(double dt) {
    timeElapsed += dt;

    final int minutes = (timeElapsed / 60).floor();
    final int seconds = timeElapsed.floor() % 60;
    final int centiseconds = ((timeElapsed % 1) * 100).floor();

    final m = minutes.toString().padLeft(2, '0');
    final s = seconds.toString().padLeft(2, '0');
    final c = centiseconds.toString().padLeft(2, '0');

    timeText.text = '$m:$s:$c';
  }

  @override
  void update(double dt) {
    super.update(dt);
    updateTime(dt);
    world.victoryController.timeElapsed = timeElapsed;
  }
}
