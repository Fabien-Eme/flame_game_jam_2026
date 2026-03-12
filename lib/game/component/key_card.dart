import 'package:flame/components.dart';
import 'dart:ui';

import '../../utils/palette.dart';
import '../game.dart';
import '../level/level2_initialization.dart';
import '../level/level3_initialization.dart';
import '../level/level_world.dart';
import 'bb_camera.dart';

class KeyCard extends PositionComponent with HasWorldReference<LevelWorld>, HasGameReference<FGJ2026> {
  KeyCard({required super.position, required this.color, super.key});

  final Color color;

  bool isSelected = false;

  late final Paint paint;

  @override
  void onLoad() {
    priority = 10;

    paint = Paint()..color = color;

    add(RectangleComponent(anchor: Anchor.center, position: Vector2.zero(), size: Vector2(10, 20), paint: paint));

    super.onLoad();
  }

  void select() {
    isSelected = true;
    paint.color = Palette.green;
  }

  void deselect() {
    isSelected = false;
    paint.color = color;
  }

  void pickUp() async {
    game.keycardController.pickUpKeyCard(color, world.keyCardHUD);

    final List<BBCamera> bbCameras = [];

    bbCameras.addAll(world.bbCameras);

    for (var bbCamera in bbCameras) {
      bbCamera.keyCardTrigger(color);
      bbCamera.removeOnKeyCardTrigger(color);
    }

    if (color == Palette.darkYellow) {
      level2Initialization(world, game.keycardController.keyCardsOwned);
    }
    if (color == Palette.orange) {
      level3Initialization(world, game.keycardController.keyCardsOwned);
    }
    removeFromParent();
  }
}
