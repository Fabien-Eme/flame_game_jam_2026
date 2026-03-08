import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../level/level.dart';
import '../menu/main_menu.dart' show MainMenu;
import '../menu/root.dart';
import 'route_can_ignore_events.dart';

class GameRouter extends RouterComponent {
  GameRouter()
    : super(
        initialRoute: 'root',
        routes: {
          'root': RouteCanIgnoreEvents(Root.new),

          ///
          'mainMenu': RouteCanIgnoreEvents(MainMenu.new, transparent: true),
          //'menuSettings': RouteMakeOtherIgnoreEvents(MenuSettings.new, transparent: true),

          ///
          'level1': RouteCanIgnoreEvents(() => Level(key: ComponentKey.named('level'), currentLevel: 1)),
        },
      );
}
