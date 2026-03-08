import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'game/game.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

  runApp(
    GameWidget(
      game: FGJ2026(),
    ),
  );
}