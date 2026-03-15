import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame_game_jam_2026/game/game.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../../utils/palette.dart';

class SpeedrunWonComponent extends PositionComponent
    with HasGameReference<FGJ2026>, KeyboardHandler {
  SpeedrunWonComponent({
    required super.position,
    required this.timeElapsed,
    required this.onSubmit,
    required this.onUploaded,
    super.key,
  });

  final double timeElapsed;
  final Future<void> Function(String playerName) onSubmit;
  final VoidCallback onUploaded;

  static const int _maxNameLength = 12;

  String _playerName = '';
  bool _isUploading = false;
  bool _hasUploaded = false;

  late final TextComponent _nameValueText;
  late final TextComponent _statusText;
  @override
  FutureOr<void> onLoad() {
    anchor = Anchor.center;

    addAll([
      TextComponent(
        anchor: Anchor.center,
        position: Vector2(0, -180),
        text: 'Speedrun complete!',
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: 48,
            color: Palette.trueBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      TextComponent(
        anchor: Anchor.center,
        position: Vector2(0, -120),
        text: 'Final time: ${_formatTime(timeElapsed)}',
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: 36,
            color: Palette.trueBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      TextComponent(
        anchor: Anchor.center,
        position: Vector2(0, -50),
        text: 'Enter your name to upload your highscore',
        textRenderer: TextPaint(
          style: TextStyle(fontSize: 28, color: Palette.trueBlack),
        ),
      ),
      TextComponent(
        anchor: Anchor.center,
        position: Vector2(0, 0),
        text: 'Name',
        textRenderer: TextPaint(
          style: TextStyle(fontSize: 24, color: Palette.trueBlack),
        ),
      ),
      RectangleComponent(
        anchor: Anchor.center,
        position: Vector2(0, 55),
        size: Vector2(360, 64),
        paint: Paint()..color = Palette.trueBlack,
      ),
      RectangleComponent(
        anchor: Anchor.center,
        position: Vector2(0, 55),
        size: Vector2(352, 56),
        paint: Paint()..color = Palette.white,
      ),
      _nameValueText = TextComponent(
        anchor: Anchor.center,
        position: Vector2(0, 55),
        text: '_',
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: 34,
            color: Palette.trueBlack,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ),
      TextComponent(
        anchor: Anchor.center,
        position: Vector2(0, 110),
        text: 'Letters, numbers and spaces only',
        textRenderer: TextPaint(
          style: TextStyle(fontSize: 20, color: Palette.trueBlack),
        ),
      ),
      ButtonComponent(
        position: Vector2(0, 175),
        anchor: Anchor.center,
        button: TextComponent(
          text: 'UPLOAD SCORE',
          textRenderer: TextPaint(
            style: TextStyle(
              fontSize: 30,
              color: Palette.trueBlack,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onPressed: _trySubmit,
      ),
      _statusText = TextComponent(
        anchor: Anchor.center,
        position: Vector2(0, 240),
        text: 'Press Enter to submit',
        textRenderer: TextPaint(
          style: TextStyle(fontSize: 24, color: Palette.trueBlack),
        ),
      ),
    ]);

    return super.onLoad();
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is! KeyDownEvent) {
      return true;
    }

    if (_hasUploaded || _isUploading) {
      return true;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter) {
      unawaited(_trySubmit());
      return true;
    }

    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_playerName.isNotEmpty) {
        _playerName = _playerName.substring(0, _playerName.length - 1);
        _refreshName();
      }
      return true;
    }

    final character = event.character;
    if (character == null || character.isEmpty) {
      return true;
    }

    if (_playerName.length >= _maxNameLength) {
      return true;
    }

    final normalizedCharacter = character.toUpperCase();
    final isAllowed =
        RegExp(r'^[A-Z0-9 ]$').hasMatch(normalizedCharacter);
    if (!isAllowed) {
      return true;
    }

    _playerName += normalizedCharacter;
    _refreshName();
    return true;
  }

  Future<void> _trySubmit() async {
    final trimmedName = _playerName.trim();
    if (trimmedName.isEmpty) {
      _statusText.text = 'Please enter a name first';
      return;
    }

    _isUploading = true;
    _statusText.text = 'Uploading...';

    try {
      await onSubmit(trimmedName);
      _hasUploaded = true;
      _statusText.text = 'Highscore uploaded. Press any bound action to continue';
      onUploaded();
    } catch (_) {
      _statusText.text = 'Upload failed. Press Enter to retry';
    } finally {
      _isUploading = false;
    }
  }

  void _refreshName() {
    _nameValueText.text = _playerName.isEmpty ? '_' : _playerName;
    _statusText.text = 'Press Enter to submit';
  }

  String _formatTime(double time) {
    final minutes = (time / 60).floor();
    final seconds = time.floor() % 60;
    final centiseconds = ((time % 1) * 100).floor();

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}:${centiseconds.toString().padLeft(2, '0')}';
  }
}
