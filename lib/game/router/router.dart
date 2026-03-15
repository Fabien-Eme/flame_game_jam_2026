import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../level/level.dart';
import '../menu/gamepad_configuration.dart';
import '../menu/main_menu.dart' show MainMenu;
import '../menu/root.dart';
import '../menu/loading_screen.dart';
import '../menu/settings.dart';
import 'route_can_ignore_events.dart';

class GameRouter extends RouterComponent {
  GameRouter()
    : super(
        initialRoute: 'root',
        routes: {
          'root': RouteCanIgnoreEvents(Root.new),

          ///
          'mainMenu': RouteCanIgnoreEvents(MainMenu.new, transparent: true),
          'settings': RouteCanIgnoreEvents(Settings.new, transparent: true),
          'gamepadConfiguration': RouteCanIgnoreEvents(GamepadConfiguration.new, transparent: true),

          ///
          'level': RouteCanIgnoreEvents(() => Level(key: ComponentKey.named('level'))),
          'speedRunMode': RouteCanIgnoreEvents(() => Level(key: ComponentKey.named('level'), speedRunMode: true)),
          'newGame': RouteCanIgnoreEvents(() => Level(key: ComponentKey.named('level'), newGame: true)),

          ///
          'loading': RouteCanIgnoreEvents(() => LoadingScreen(key: ComponentKey.named('loading'))),
          'loadingSpeedRunMode': RouteCanIgnoreEvents(() => LoadingScreen(key: ComponentKey.named('loadingSpeedRunMode'), isSpeedRunMode: true)),
        },
      );
}
