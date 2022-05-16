import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextService {
  final SpeechToText _speechToText;

  SpeechToTextService({required SpeechToText speechToText})
      : _speechToText = speechToText;

  String? _lastWords;

  bool get isInitialize => _speechToText.isAvailable;

  SpeechToText get speechToText => _speechToText;

  String get lastWords => _lastWords ?? '';

  bool get isListening => _speechToText.isListening;

  Future<void> initService() async {
    await _speechToText.initialize();
  }

  Future<void> startListen(
      {required void Function(SpeechRecognitionResult) onResult}) async {
    _lastWords = '';

    await _speechToText.listen(
      onResult: onResult,
      partialResults: true,
    );
  }

  Future<void> stopListen() async {
    await _speechToText.stop();
  }
}
