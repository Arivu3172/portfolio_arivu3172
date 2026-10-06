import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Portfolio narrator powered by device / browser text-to-speech.
class VoiceTts extends ChangeNotifier {
  VoiceTts._();

  static final VoiceTts instance = VoiceTts._();

  final FlutterTts _tts = FlutterTts();
  bool enabled = true;
  bool speaking = false;
  bool _ready = false;
  String? _activeText;

  Future<void> init() async {
    if (_ready) return;
    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.44);
      await _tts.setVolume(1.0);
      await _tts.setPitch(0.95);

      // Prefer a clearer English voice when the platform exposes one.
      try {
        final voices = await _tts.getVoices;
        if (voices is List) {
          Map<String, dynamic>? match;
          for (final v in voices) {
            if (v is! Map) continue;
            final map = Map<String, dynamic>.from(v);
            final locale = '${map['locale'] ?? ''}'.toLowerCase();
            final name = '${map['name'] ?? ''}'.toLowerCase();
            if (locale.contains('en') &&
                (name.contains('female') ||
                    name.contains('samantha') ||
                    name.contains('zira') ||
                    name.contains('google'))) {
              match = map;
              break;
            }
          }
          if (match != null) {
            await _tts.setVoice({
              'name': '${match['name']}',
              'locale': '${match['locale']}',
            });
          }
        }
      } catch (_) {
        // Voice selection is best-effort.
      }

      _tts.setStartHandler(() {
        speaking = true;
        notifyListeners();
      });
      _tts.setCompletionHandler(() {
        speaking = false;
        _activeText = null;
        notifyListeners();
      });
      _tts.setCancelHandler(() {
        speaking = false;
        _activeText = null;
        notifyListeners();
      });
      _tts.setErrorHandler((msg) {
        speaking = false;
        _activeText = null;
        notifyListeners();
        if (kDebugMode) debugPrint('VoiceTts error: $msg');
      });

      _ready = true;
    } catch (e) {
      if (kDebugMode) debugPrint('VoiceTts init: $e');
    }
  }

  Future<void> speak(String text) async {
    final clean = text.trim();
    if (!enabled || clean.isEmpty) return;

    try {
      await init();
      if (speaking && _activeText == clean) {
        await stop();
        return;
      }
      await _tts.stop();
      _activeText = clean;
      speaking = true;
      notifyListeners();
      await _tts.speak(clean);
    } catch (e) {
      speaking = false;
      _activeText = null;
      notifyListeners();
      if (kDebugMode) debugPrint('VoiceTts speak: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
    speaking = false;
    _activeText = null;
    notifyListeners();
  }

  void toggleEnabled() {
    enabled = !enabled;
    if (!enabled) {
      stop();
    }
    notifyListeners();
  }

  bool isSpeakingText(String text) => speaking && _activeText == text.trim();
}
