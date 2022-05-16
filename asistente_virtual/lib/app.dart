import 'package:asistente_virtual/dependency_injection/dependency_injection.dart';
import 'package:asistente_virtual/router/router.dart';
import 'package:asistente_virtual/services/speech_to_text_service.dart';
import 'package:asistente_virtual/services/text_to_speed_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerStatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late TextToSpeechService _textToSpeechService;
  late SpeechToTextService _speechToTextService;
  final _appRouter = AppAutoRouter();

  Future<void> initServices() async {
    await _textToSpeechService.initService();
    await _speechToTextService.initService();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    _textToSpeechService = ref.watch(textToSpeechServiceProvider);
    _speechToTextService = ref.watch(speechToTextServiceProvider);

    return FutureBuilder(
      future: initServices(),
      builder: (context, snapshot) => MaterialApp.router(
        routerDelegate: _appRouter.delegate(),
        routeInformationParser: _appRouter.defaultRouteParser(),
      ),
    );
  }
}
