import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/rendering.dart';
import '../../utils/palette.dart';
import '../controller/highscore_service.dart';
import 'dart:async';

class HighscoreComponent extends PositionComponent with HasWorldReference<World> {
  HighscoreComponent({required super.position, super.key});

  TextComponent loadingText = TextComponent();
  RectangleComponent loadingBar = RectangleComponent();
  RectangleComponent loadingBarStroke = RectangleComponent();

  List<dynamic> scores = [];

  @override
  FutureOr<void> onLoad() async {
    add(
      TextComponent(
        anchor: Anchor.topCenter,
        text: 'Highscores',
        textRenderer: TextPaint(style: TextStyle(fontSize: 30, color: Palette.white)),
      ),
    );

    add(
      loadingText = TextComponent(
        anchor: Anchor.topCenter,
        position: Vector2(0, 40),
        text: 'Loading...',
        textRenderer: TextPaint(style: TextStyle(fontSize: 30, color: Palette.white)),
      ),
    );

    add(
      loadingBar = RectangleComponent(
        anchor: Anchor.topLeft,
        position: Vector2(-100, 100),
        size: Vector2(0, 10),
        paint: Paint()..color = Palette.white,
      ),
    );

    add(
      loadingBarStroke = RectangleComponent(
        anchor: Anchor.topCenter,
        size: Vector2(200, 10),
        position: Vector2(0, 100),
        paint: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Palette.white,
      ),
    );

    fetchScores();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (loadingBar.size.x < 200) {
      loadingBar.size = Vector2(loadingBar.size.x + 200 / 5 * dt, 10);
    } else {
      loadingBar.size = Vector2(200, 10);
    }
  }

  Future<void> fetchScores() async {
    scores = await HighscoreService.fetchScores();
    loadingText.removeFromParent();
    loadingBar.removeFromParent();
    loadingBarStroke.removeFromParent();

    const double rowWidth = 200;
    const double rowHeight = 30;

    add(
      ColumnComponent(
        position: Vector2(0, 40),
        anchor: Anchor.topCenter,
        children: scores.map((score) {
          return PositionComponent(
            size: Vector2(rowWidth, rowHeight),
            children: [
              TextComponent(
                text: score['name'].toString().toUpperCase(),
                anchor: Anchor.centerLeft,
                position: Vector2(0, rowHeight / 2),
                textRenderer: TextPaint(style: TextStyle(fontSize: 20, color: Palette.white)),
              ),
              TextComponent(
                text: formatTime(score['score']),
                anchor: Anchor.centerRight,
                position: Vector2(rowWidth, rowHeight / 2),
                textRenderer: TextPaint(
                  style: TextStyle(fontSize: 20, color: Palette.white, fontFamily: 'monospace'),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  String formatTime(num time) {
    int minutes = (time / 60).floor();
    int seconds = time.floor() % 60;
    int centiseconds = ((time % 1) * 100).floor();

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}:${centiseconds.toString().padLeft(2, '0')}';
  }
}
