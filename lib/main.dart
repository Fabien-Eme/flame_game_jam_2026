import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import 'game/game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SoLoud.instance.init(sampleRate: 44100, bufferSize: 2048, channels: Channels.stereo);

  runApp(GameWidget(game: FGJ2026()));
}
