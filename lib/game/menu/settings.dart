import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_game_jam_2026/game/game.dart';
import 'package:flame_game_jam_2026/game/level/post_process.dart';
import 'package:flame_game_jam_2026/utils/palette.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../component/back_button.dart';
import '../component/custom_text_button.dart';

class Settings extends PositionComponent with HasGameReference<FGJ2026> {
  final World world = World();
  late final CameraComponent cameraComponent;
  late final CustomTextButton buttonShader;

  TextComponent musicVolumeText = TextComponent(
    anchor: Anchor.center,
    text: '100',
    textRenderer: TextPaint(style: TextStyle(fontSize: 30, color: Palette.white)),
  );

  TextComponent soundVolumeText = TextComponent(
    anchor: Anchor.center,
    text: '100',
    textRenderer: TextPaint(style: TextStyle(fontSize: 30, color: Palette.white)),
  );

  @override
  FutureOr<void> onLoad() async {
    musicVolumeText.text = game.audioController.musicVolume.toString();
    soundVolumeText.text = game.audioController.soundVolume.toString();

    await add(world);

    await add(cameraComponent = CameraComponent.withFixedResolution(width: FGJ2026.gameWidth, height: FGJ2026.gameHeight, world: world));

    cameraComponent.postProcess = game.postProcessing ? CRTPostProcess() : null;

    world.add(
      RectangleComponent.fromRect(
        Rect.fromLTWH(-FGJ2026.gameWidth / 2, -FGJ2026.gameHeight / 2, FGJ2026.gameWidth, FGJ2026.gameHeight),
        paint: Paint()..color = Palette.veryDarkGrey,
      ),
    );

    world.add(
      ColumnComponent(
        anchor: Anchor.center,
        gap: 30,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextComponent(
            text: 'MUSIC    ',
            textRenderer: TextPaint(style: TextStyle(fontSize: 30, color: Palette.white)),
          ),
          RowComponent(
            children: [
              CustomTextButton(text: '-             ', onPressed: (game, world) => musicVolumeDown()),

              musicVolumeText,
              CustomTextButton(text: '       +', onPressed: (game, world) => musicVolumeUp()),
            ],
          ),

          TextComponent(
            text: 'SOUND    ',
            textRenderer: TextPaint(style: TextStyle(fontSize: 30, color: Palette.white)),
          ),
          RowComponent(
            children: [
              CustomTextButton(text: '-          ', onPressed: (game, world) => soundVolumeDown()),
              soundVolumeText,
              CustomTextButton(text: '       +', onPressed: (game, world) => soundVolumeUp()),
            ],
          ),
          TextComponent(
            text: '',
            textRenderer: TextPaint(style: TextStyle(fontSize: 30, color: Palette.white)),
          ),
          TextComponent(
            text: 'POST PROCESSING',
            textRenderer: TextPaint(style: TextStyle(fontSize: 30, color: Palette.white)),
          ),

          buttonShader = CustomTextButton(
            text: (game.postProcessing ? 'ON' : 'OFF'),
            onPressed: (game, world) {
              game.postProcessing = !game.postProcessing;
              cameraComponent.postProcess = game.postProcessing ? CRTPostProcess() : null;
              buttonShader.text = (game.postProcessing ? 'ON' : 'OFF');
              final asyncPrefs = SharedPreferencesAsync();
              asyncPrefs.setBool('postProcessing', game.postProcessing);
            },
          ),

          TextComponent(
            text: '',
            textRenderer: TextPaint(style: TextStyle(fontSize: 30, color: Palette.white)),
          ),

          BackButton(),
        ],
      ),
    );

    return super.onLoad();
  }

  void musicVolumeDown() {
    game.audioController.musicVolumeDown();
    musicVolumeText.text = game.audioController.musicVolume.toString();
  }

  void musicVolumeUp() {
    game.audioController.musicVolumeUp();
    musicVolumeText.text = game.audioController.musicVolume.toString();
  }

  void soundVolumeDown() {
    game.audioController.soundVolumeDown();
    soundVolumeText.text = game.audioController.soundVolume.toString();
  }

  void soundVolumeUp() {
    game.audioController.soundVolumeUp();
    soundVolumeText.text = game.audioController.soundVolume.toString();
  }
}
