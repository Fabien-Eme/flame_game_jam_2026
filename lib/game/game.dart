import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:gamepads/gamepads.dart';

import '../utils/game_assets.dart';
import '../utils/palette.dart';
import 'level/level.dart';
import 'router/router.dart';

class FGJ2026 extends FlameGame with MouseMovementDetector {
  static const double gameWidth = 1280;
  static const double gameHeight = 720;

  late final RouterComponent router;

  Vector2 mousePosition = Vector2.zero();

  @override
  FutureOr<void> onLoad() async {
    /// Preload all images
    images.prefix = '';
    final futurePreLoadImages = preLoadAssetsImages().map((loadableBuilder) => loadableBuilder());
    await Future.wait<void>(futurePreLoadImages);

    /// Register component for queries
    children.register<Level>();

    /// Add router
    add(router = GameRouter());

    if (kDebugMode) add(FpsTextComponent());

    return super.onLoad();
  }


  @override
  void onMouseMove(PointerHoverInfo info) {
    super.onMouseMove(info);

    mousePosition = info.eventPosition.widget;
  }

  

  @override
  Color backgroundColor() {
    return Palette.trueBlack;
  }
}
