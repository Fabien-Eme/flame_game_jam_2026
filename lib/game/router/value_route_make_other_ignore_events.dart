import 'package:flame/game.dart';
import 'route_can_ignore_events.dart';

class ValueRouteMakeOtherIgnoreEvents extends ValueRoute<ValueRouteResult> {
  bool doesPutGameInPause;
  ValueRouteMakeOtherIgnoreEvents({this.doesPutGameInPause = false, super.transparent = true, super.value = ValueRouteResult.nullResult});

  @override
  void onPush(Route? previousRoute) {
    if (previousRoute.runtimeType == RouteCanIgnoreEvents) {
      (previousRoute as RouteCanIgnoreEvents?)?.ignoreEvents = true;
    }
    if (doesPutGameInPause) previousRoute?.stopTime();
    super.onPush(previousRoute);
  }

  @override
  void didPop(Route nextRoute) {
    if (nextRoute.runtimeType == RouteCanIgnoreEvents) {
      (nextRoute as RouteCanIgnoreEvents).ignoreEvents = false;
    }
    if (doesPutGameInPause) nextRoute.resumeTime();
    super.didPop(nextRoute);
  }
}

enum ValueRouteResult {
  nullResult,
  bribe,
  sufferDamage,
}
