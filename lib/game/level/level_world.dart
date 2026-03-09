import 'package:flame/components.dart';
import 'package:flame_game_jam_2026/game/component/room.dart';

import '../component/door.dart';

class LevelWorld extends World {
  List<Room> rooms = [];
  List<Door> doors = [];
}
