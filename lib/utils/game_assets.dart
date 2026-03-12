import 'package:flame/extensions.dart';

import '../game/game.dart';

extension GameAssets on FGJ2026 {
  List<Future<Image> Function()> preLoadAssetsImages() {
    return [
      //for (AssetGenImage element in Assets.values) () => images.load(element.path),
    ];
  }
}
