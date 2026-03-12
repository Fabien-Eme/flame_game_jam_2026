import 'package:flame/components.dart';
import 'package:flame_game_jam_2026/game/level/level_world.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../component/check_point.dart';
import '../game.dart';

class CheckpointController extends Component with HasGameReference<FGJ2026> {
  CheckpointController({super.key});

  int currentCheckpoint = 0;

  @override
  void onLoad() {
    super.onLoad();
  }

  Future<int> getCurrentCheckpointInMemory() async {
    final asyncPrefs = SharedPreferencesAsync();

    //TODO Remove Debug
    await asyncPrefs.setInt('currentCheckpoint', 6);

    final currentCheckpoint = await asyncPrefs.getInt('currentCheckpoint');
    this.currentCheckpoint = currentCheckpoint ?? 0;
    return this.currentCheckpoint;
  }

  Future<void> saveCheckpoint(int checkpoint) async {
    final asyncPrefs = SharedPreferencesAsync();
    int savedCheckpoint = await asyncPrefs.getInt('currentCheckpoint') ?? 0;
    if (savedCheckpoint < checkpoint) {
      asyncPrefs.setInt('currentCheckpoint', checkpoint);
      currentCheckpoint = checkpoint;
    }
    game.keycardController.saveKeyCard();
  }

  Future<void> resetCheckpoint() async {
    final asyncPrefs = SharedPreferencesAsync();
    await asyncPrefs.remove('currentCheckpoint');
    currentCheckpoint = 0;
  }

  Vector2 getCurrentCheckpointPosition(List<CheckPoint> checkPoints) {
    return getCheckpointPosition(checkPoints, currentCheckpoint);
  }

  Vector2 getCheckpointPosition(List<CheckPoint> checkPoints, int checkpointId) {
    return checkPoints.firstWhere((checkPoint) => checkPoint.id == checkpointId).position;
  }

  void markCheckpointAlreadyReached(LevelWorld levelWorld) {
    for (var checkPoint in levelWorld.checkPoints) {
      if (checkPoint.id <= currentCheckpoint) {
        checkPoint.markAsAlreadyReached();
      }
    }
  }
}
