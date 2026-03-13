import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_game_jam_2026/game/level/level2_initialization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/palette.dart';
import '../component/key_card_hud.dart';
import '../level/level3_initialization.dart';
import '../level/level_world.dart';
import '../game.dart';

class KeycardController extends Component with HasGameReference<FGJ2026> {
  KeycardController({super.key});

  List<Color> keyCardsOwned = [];
  List<String> keyCardsOwnedString = [];

  @override
  void onLoad() {
    super.onLoad();
  }

  void pickUpKeyCard(Color color, KeyCardHUD keyCardHUD) {
    keyCardsOwned.add(color);
    keyCardHUD.addKeyCard(color);
    game.audioController.playKeyCollectedSound();
  }

  Future<void> resetKeyCards([KeyCardHUD? keyCardHUD]) async {
    keyCardsOwned.clear();
    keyCardsOwnedString.clear();

    keyCardHUD?.resetKeyCards();
    final asyncPrefs = SharedPreferencesAsync();
    await asyncPrefs.remove('keyCardsOwnedString');
  }

  Future<List<Color>> getKeyCardsInMemory([KeyCardHUD? keyCardHUD]) async {
    final asyncPrefs = SharedPreferencesAsync();

    final keyCardsOwnedString = await asyncPrefs.getStringList('keyCardsOwnedString');
    this.keyCardsOwnedString = keyCardsOwnedString ?? [];

    keyCardsOwned.clear();
    if (keyCardsOwnedString != null) {
      for (var keyCard in keyCardsOwnedString) {
        if (keyCard == 'lightBlue') {
          keyCardsOwned.add(Palette.lightBlue);
        }
        if (keyCard == 'red') {
          keyCardsOwned.add(Palette.red);
        }
        if (keyCard == 'darkYellow') {
          keyCardsOwned.add(Palette.darkYellow);
        }
        if (keyCard == 'orange') {
          keyCardsOwned.add(Palette.orange);
        }
      }
    }

    for (var keyCard in keyCardsOwned) {
      keyCardHUD?.addKeyCard(keyCard);
    }

    return keyCardsOwned;
  }

  void saveKeyCard() {
    final asyncPrefs = SharedPreferencesAsync();
    keyCardsOwnedString.clear();

    for (var keyCard in keyCardsOwned) {
      if (keyCard == Palette.lightBlue) {
        keyCardsOwnedString.add('lightBlue');
      }
      if (keyCard == Palette.red) {
        keyCardsOwnedString.add('red');
      }
      if (keyCard == Palette.darkYellow) {
        keyCardsOwnedString.add('darkYellow');
      }
      if (keyCard == Palette.orange) {
        keyCardsOwnedString.add('orange');
      }
    }
    asyncPrefs.setStringList('keyCardsOwnedString', keyCardsOwnedString);
  }

  void removeKeyCardAlreadyCollected(LevelWorld levelWorld) {
    for (var keyCard in levelWorld.keyCards) {
      if (keyCardsOwned.contains(keyCard.color)) {
        keyCard.removeFromParent();
      }
    }
  }
}
