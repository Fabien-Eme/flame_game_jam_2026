import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import '../level/level_world.dart';

class BBCamera extends PositionComponent with HasWorldReference<LevelWorld> {
  late final int id;
  double maxDistance;
  double startAngle;
  double angleSpeed;
  bool isRotating;
  double rotationAmplitude;
  late final double initialAngle;
  late final Vector2 initialPosition;
  bool isGoingClockwise;
  bool isMoving;
  bool isMovingVertically;
  double? movingSpeed;
  double? movingAmplitude;
  bool goingUpOrRight;
  Color? keyCardColorTrigger;
  final void Function(BBCamera camera)? keyCardTriggerFunction;
  Color? removeOnKeyCardTriggerColor;
  late final int numberOfRays;
  double? angleCovered;

  BBCamera({
    required super.position,
    required this.maxDistance,
    this.startAngle = 0,
    this.angleSpeed = 1,
    this.isRotating = false,
    this.rotationAmplitude = pi / 4,
    this.angleCovered,
    this.isGoingClockwise = true,
    this.isMoving = false,
    this.isMovingVertically = false,
    this.movingSpeed = 100,
    this.movingAmplitude,
    this.goingUpOrRight = true,
    this.keyCardColorTrigger,
    this.keyCardTriggerFunction,
    this.removeOnKeyCardTriggerColor,
    super.key,
  });

  bool doesSeePlayer = false;

  @override
  void onLoad() {
    super.onLoad();
    priority = 10;
    id = world.bbCameras.length;

    startAngle = startAngle + pi / 2;
    initialAngle = startAngle;
    initialPosition = position.clone();

    angleCovered ??= rotationAmplitude;
    numberOfRays = max(15, (52 * (maxDistance / 250) * (angleCovered! / (pi / 4))).round());
  }

  void keyCardTrigger(Color color) {
    if (keyCardColorTrigger != null && color == keyCardColorTrigger) {
      keyCardTriggerFunction?.call(this);
    }
  }

  void removeOnKeyCardTrigger(Color color) {
    if (removeOnKeyCardTriggerColor != null && color == removeOnKeyCardTriggerColor) {
      world.rayController.removeBBCamera(this);
      removeFromParent();
      world.bbCameras.remove(this);
    }
  }

  @override
  void update(double dt) {
    if (world.isPaused) return;
    if (isRotating) {
      if (isGoingClockwise) {
        startAngle += pi / 4 * angleSpeed * dt;
      } else {
        startAngle -= pi / 4 * angleSpeed * dt;
      }
    }
    if (rotationAmplitude != null) {
      if (startAngle >= initialAngle + rotationAmplitude! / 2) {
        isGoingClockwise = false;
      } else if (startAngle < initialAngle - rotationAmplitude! / 2) {
        isGoingClockwise = true;
      }
    }

    if (isMoving) {
      if (isMovingVertically) {
        position.y += movingSpeed! * 0.5 * dt * (goingUpOrRight ? -1 : 1);
      } else {
        position.x += movingSpeed! * 0.5 * dt * (goingUpOrRight ? -1 : 1);
      }
    }
    if (movingAmplitude != null) {
      if (isMovingVertically) {
        if (position.y >= initialPosition.y + movingAmplitude! / 2) {
          goingUpOrRight = true;
        } else if (position.y < initialPosition.y - movingAmplitude! / 2) {
          goingUpOrRight = false;
        }
      } else {
        if (position.x >= initialPosition.x + movingAmplitude! / 2) {
          goingUpOrRight = true;
        } else if (position.x < initialPosition.x - movingAmplitude! / 2) {
          goingUpOrRight = false;
        }
      }
    }
    super.update(dt);
  }
}
