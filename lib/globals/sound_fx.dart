import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Lightweight cinematic SFX helper. Failures are ignored (web autoplay, etc.).
class SoundFx {
  SoundFx._();

  static final SoundFx instance = SoundFx._();

  final AudioPlayer _oneShot = AudioPlayer();
  bool enabled = true;
  bool _ready = false;

  static const click = 'sounds/click.wav';
  static const whoosh = 'sounds/whoosh.wav';
  static const hit = 'sounds/hit.wav';
  static const chime = 'sounds/chime.wav';

  Future<void> init() async {
    if (_ready) return;
    try {
      await _oneShot.setReleaseMode(ReleaseMode.stop);
      await _oneShot.setVolume(0.55);
      _ready = true;
    } catch (e) {
      if (kDebugMode) debugPrint('SoundFx init: $e');
    }
  }

  Future<void> play(String asset, {double volume = 0.55}) async {
    if (!enabled) return;
    try {
      await init();
      await _oneShot.stop();
      await _oneShot.setVolume(volume);
      await _oneShot.play(AssetSource(asset));
    } catch (e) {
      if (kDebugMode) debugPrint('SoundFx play($asset): $e');
    }
  }

  Future<void> playClick() => play(click, volume: 0.35);
  Future<void> playWhoosh() => play(whoosh, volume: 0.45);
  Future<void> playHit() => play(hit, volume: 0.5);
  Future<void> playChime() => play(chime, volume: 0.4);

  void toggle() => enabled = !enabled;

  Future<void> dispose() async {
    await _oneShot.dispose();
    _ready = false;
  }
}
