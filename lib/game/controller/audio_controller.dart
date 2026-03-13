import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_game_jam_2026/game/game.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioController extends Component with HasGameReference<FGJ2026> {
  int musicVolume = 100;
  int soundVolume = 100;

  late final SoundHandle musicHandle;

  late final AudioSource cameraDetectionSound;
  late final AudioSource keyCollectedSound;
  late final AudioSource checkpointReachedSound;
  late final AudioSource menuClickSound;
  late final AudioSource doorSound;
  late final AudioSource victorySound;

  late final SharedPreferencesAsync asyncPrefs;

  @override
  FutureOr<void> onLoad() async {
    /// Retrieve volumes from shared preferences
    asyncPrefs = SharedPreferencesAsync();
    musicVolume = await asyncPrefs.getInt('musicVolume') ?? 100;
    soundVolume = await asyncPrefs.getInt('soundVolume') ?? 100;

    /// Preload all sounds
    final music = await SoLoud.instance.loadAsset('assets/music.wav', mode: LoadMode.disk);
    cameraDetectionSound = await SoLoud.instance.loadAsset('assets/camera_detection.wav', mode: LoadMode.disk);
    keyCollectedSound = await SoLoud.instance.loadAsset('assets/key_collected.wav', mode: LoadMode.disk);
    checkpointReachedSound = await SoLoud.instance.loadAsset('assets/checkpoint.wav', mode: LoadMode.disk);
    menuClickSound = await SoLoud.instance.loadAsset('assets/menu_click.wav', mode: LoadMode.disk);
    doorSound = await SoLoud.instance.loadAsset('assets/door.wav', mode: LoadMode.disk);
    victorySound = await SoLoud.instance.loadAsset('assets/victory.wav', mode: LoadMode.disk);
    musicHandle = await SoLoud.instance.play(music, looping: true);
    return super.onLoad();
  }

  void setMusicVolume(int volume) {
    SoLoud.instance.setVolume(musicHandle, volume * 0.75 / 100);
    asyncPrefs.setInt('musicVolume', volume);
  }

  void musicVolumeDown() {
    if (musicVolume <= 0) return;
    musicVolume -= 10;
    setMusicVolume(musicVolume);
  }

  void musicVolumeUp() {
    if (musicVolume >= 100) return;
    musicVolume += 10;
    setMusicVolume(musicVolume);
  }

  void soundVolumeDown() {
    if (soundVolume <= 0) return;
    soundVolume -= 10;
    asyncPrefs.setInt('soundVolume', soundVolume);
  }

  void soundVolumeUp() {
    if (soundVolume >= 100) return;
    soundVolume += 10;
    asyncPrefs.setInt('soundVolume', soundVolume);
  }

  void playCameraDetectionSound() {
    SoLoud.instance.play(cameraDetectionSound, volume: soundVolume / 100);
  }

  void playKeyCollectedSound() {
    SoLoud.instance.play(keyCollectedSound, volume: soundVolume / 35);
  }

  void playCheckpointReachedSound() {
    SoLoud.instance.play(checkpointReachedSound, volume: soundVolume / 100);
  }

  void playMenuClickSound() {
    SoLoud.instance.play(menuClickSound, volume: soundVolume / 100);
  }

  void playDoorSound() {
    SoLoud.instance.play(doorSound, volume: soundVolume / 100);
  }

  void playVictorySound() {
    SoLoud.instance.play(victorySound, volume: soundVolume / 100);
  }
}



/// music composed here : https://musiclab.chromeexperiments.com/Song-Maker/song/6176363144413184
/// sound effect made with : https://sfbgames.itch.io/chiptone