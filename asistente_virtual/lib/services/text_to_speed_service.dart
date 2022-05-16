import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

class TextToSpeechService {
  final String language = 'es_ES';
  final String engine = 'com.google.android.tts';
  final double volume = 0.6;
  final double pitch = 1.0;
  final double rate = 0.5;

  final FlutterTts _flutterTts;

  TextToSpeechService({required FlutterTts flutterTts})
      : _flutterTts = flutterTts;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  Future<void> initService() async {
    await _flutterTts.awaitSpeakCompletion(true);

    //await _flutterTts.setLanguage('es');
  }

  Future<void> speak({required String text}) async {
    await _flutterTts.speak(text);
  }

  Future stop() async {
    await _flutterTts.stop();
    ttsState = TtsState.stopped;
  }

  Future pause() async {
    await _flutterTts.pause();
    ttsState = TtsState.paused;
  }
}
