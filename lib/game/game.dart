import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';

import '../utils/game_assets.dart';
import '../utils/palette.dart';
import 'controller/audio_controller.dart';
import 'controller/checkpoint_controller.dart';
import 'controller/keycard_controller.dart';
import 'router/router.dart';

class FGJ2026 extends FlameGame {
  static const double gameWidth = 1300;
  static const double gameHeight = 700;

  late final RouterComponent router;

  late final AudioController audioController;
  late final CheckpointController checkpointController;
  late final KeycardController keycardController;

  Vector2 mousePosition = Vector2.zero();

  @override
  FutureOr<void> onLoad() async {
    await add(audioController = AudioController());
    await add(checkpointController = CheckpointController());
    await add(keycardController = KeycardController());

    await checkpointController.getCurrentCheckpointInMemory();

    /// Preload all images
    images.prefix = '';
    final futurePreLoadImages = preLoadAssetsImages().map((loadableBuilder) => loadableBuilder());
    await Future.wait<void>(futurePreLoadImages);

    /// Add router
    add(router = GameRouter());

    if (kDebugMode) add(FpsTextComponent());

    return super.onLoad();
  }

  @override
  Color backgroundColor() {
    return Palette.trueBlack;
  }
}
