import 'package:asistente_virtual/services/notes_service.dart';
import 'package:asistente_virtual/services/speech_to_text_service.dart';
import 'package:asistente_virtual/services/text_to_speed_service.dart';
import 'package:asistente_virtual/services/todo_service.dart';
import 'package:asistente_virtual/utils/constants.dart';
import 'package:asistente_virtual/utils/extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class AsistanceState {
  late bool isListening;
  late bool isSpeaking;
  late String lastWords;
  late String lastError;

  AsistanceState({
    this.isListening = false,
    this.isSpeaking = false,
    this.lastWords = '',
    this.lastError = '',
  });

  AsistanceState copyWith({
    bool? isListening,
    bool? isSpeaking,
    String? lastWords,
    String? lastError,
  }) {
    return AsistanceState(
      isListening: isListening ?? this.isListening,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      lastWords: lastWords ?? this.lastWords,
      lastError: lastError ?? this.lastError,
    );
  }
}

class AsistanceNotifier extends StateNotifier<AsistanceState> {
  final TextToSpeechService _textToSpeechService;
  final SpeechToTextService _speechToTextService;
  final NotesService _notesService;
  final TodosService _todosService;

  AsistanceNotifier(
      {required TextToSpeechService textToSpeechService,
      required SpeechToTextService speechToTextService,
      required NotesService notesService,
      required TodosService todosService})
      : _textToSpeechService = textToSpeechService,
        _speechToTextService = speechToTextService,
        _notesService = notesService,
        _todosService = todosService,
        super(
          AsistanceState(),
        );

  Future<String> _listenCommand() async {
    String words = '';
    state = state.copyWith(
        isListening: true, isSpeaking: false, lastWords: '', lastError: '');
    try {
      await _speechToTextService.startListen(
        onResult: (result) {
          words = result.recognizedWords;

          if (result.finalResult) {
            state = state.copyWith(isListening: false, lastWords: words);
          } else {
            state = state.copyWith(lastWords: words);
          }
        },
      );
    } catch (e) {
      state = state.copyWith(isListening: false, lastError: e.toString());
    }

    await Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 250));

      return state.isListening;
    });

    return words;
  }

  Future<void> _talk({required String text}) async {
    state = state.copyWith(isSpeaking: true, lastError: '');

    await _textToSpeechService
        .speak(text: text)
        .then((value) => state = state.copyWith(isSpeaking: false))
        .catchError(
          (onError) => state = state.copyWith(
            isSpeaking: false,
            lastError: onError.toString(),
          ),
        );
  }

  String _parseWebUrl({required String url}) {
    final tempUrl = url.replaceFirst(actionSearchWeb, '');
    return 'https://www.google.com/search?q=' + Uri.encodeComponent(tempUrl);
  }

  String _parseYoutubeUrl({required String url}) {
    final tempUrl = url.replaceFirst(actionSearchYoutube, '');
    return 'https://www.youtube.com/results?search_query=' +
        Uri.encodeComponent(tempUrl);
  }

  String _monthFromInt({required int monthNumber}) {
    switch (monthNumber) {
      case 1:
        return 'Enero';
      case 2:
        return 'Febrero';
      case 3:
        return 'Marzo';
      case 4:
        return 'Abril';
      case 5:
        return 'Mayo';
      case 6:
        return 'Junio';
      case 7:
        return 'Julio';
      case 8:
        return 'Agosto';
      case 9:
        return 'Septiembre';
      case 10:
        return 'Octubre';
      case 11:
        return 'Noviembre';
      case 12:
        return 'Diciembre';
      default:
        return 'Mes desconocido';
    }
  }

  Future<void> _showWebResults({required String url}) async {
    final permission = await canLaunch(url);

    if (permission) {
      await _talk(text: results);
      await launch(url);
    } else {
      await _talk(text: error);
    }
  }

  Future<void> _brain({required String question}) async {
    question = question.withoutDiacriticalMarks.toLowerCase();

    if (question == questionHelloExtends || question == questionHello) {
      await _talk(text: answerHello);
      _clearResults();
      return;
    }

    if (question == questionHelp || question == questionHelpAlt) {
      await _talk(text: answerHelp);
      _clearResults();
      return;
    }

    if (question == questionCreator || question == questionCreatorExtends) {
      await _talk(text: answerCreator);
      _clearResults();
      return;
    }

    if (question == questionSad || question == questionSadAlt) {
      await _talk(text: answerSad);
      _clearResults();
      return;
    }

    if (question.contains(actionSearchWeb)) {
      final url = _parseWebUrl(url: question);

      await _showWebResults(url: url);
      _clearResults();
      return;
    }

    if (question.contains(actionSearchYoutube)) {
      final url = _parseYoutubeUrl(url: question);

      await _showWebResults(url: url);
      _clearResults();
      return;
    }

    if (question == actionAddNote) {
      await _addNoteFlow();
      _clearResults();
      return;
    }

    if (question == actionAddTodo) {
      await _addTodoFlow();
      _clearResults();
      return;
    }

    if (question == actionTime) {
      final hour = DateTime.now().hour;
      final minute = DateTime.now().minute;
      await _talk(text: 'Son las $hour horas y $minute minutos');
      _clearResults();
      return;
    }

    if (question == actionDate) {
      final day = DateTime.now().day;
      final month = DateTime.now().month;
      final year = DateTime.now().year;
      await _talk(
          text:
              'Hoy es $day de ${_monthFromInt(monthNumber: month)} del $year');
      _clearResults();
      return;
    }

    if (question == actionListNotes) {
      await _listNotesFlow();
      _clearResults();
      return;
    }

    if (question == actionListTodos) {
      await _listTodosFlow();
      _clearResults();
      return;
    }

    await _talk(text: errorUnknow);
    _clearResults();
  }

  Future<void> _addNoteFlow() async {
    await _textToSpeechService.speak(text: addNoteFlowTitle);
    final titleNote = await _listenCommand();
    await _textToSpeechService.speak(text: addNoteFlowContent);
    final contentNote = await _listenCommand();
    await _notesService
        .addNote(title: titleNote, content: contentNote)
        .then((value) async => await _talk(text: addNoteFlowSuccess))
        .catchError(
          (onError) async => await _talk(text: addNoteFlowError),
        );
  }

  Future<void> _addTodoFlow() async {
    await _textToSpeechService.speak(text: addTodoFlowTitle);
    final titleTodo = await _listenCommand();
    await _todosService
        .addTodo(title: titleTodo)
        .then((value) async => await _talk(text: addTodoFlowSuccess))
        .catchError(
          (onError) async => await _talk(text: addTodoFlowError),
        );
  }

  Future<void> _listNotesFlow() async {
    final notes = await _notesService.notesList();
    for (var note in notes) {
      await _talk(
          text: 'Nota con título ${note.title} y contenido ${note.content}');
    }
  }

  Future<void> _listTodosFlow() async {
    final todos = await _todosService.todosList();
    for (var todo in todos) {
      await _talk(text: 'Tarea con título ${todo.title}');
    }
  }

  void _clearResults() {
    state = state.copyWith(
      isListening: false,
      isSpeaking: false,
      lastWords: '',
      lastError: '',
    );
  }

  Future<void> start() async {
    final question = await _listenCommand();

    await _brain(question: question);
  }
}
