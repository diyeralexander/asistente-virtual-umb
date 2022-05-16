import 'package:asistente_virtual/notifiers/asistance_notifier.dart';
import 'package:asistente_virtual/notifiers/manipulate_note_notifier.dart';
import 'package:asistente_virtual/notifiers/notes_notifier.dart';
import 'package:asistente_virtual/notifiers/todos_notifier.dart';
import 'package:asistente_virtual/services/text_to_speed_service.dart';
import 'package:asistente_virtual/services/todo_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../services/notes_service.dart';
import '../services/speech_to_text_service.dart';

final speechToTextProvider = Provider<SpeechToText>((ref) {
  final _speechToText = SpeechToText();
  return _speechToText;
});

final speechToTextServiceProvider = Provider<SpeechToTextService>((ref) {
  final _speechToText = ref.watch(speechToTextProvider);
  final _speechToTextService = SpeechToTextService(speechToText: _speechToText);
  return _speechToTextService;
});

final textToSpeechProvider = Provider<FlutterTts>((ref) {
  final _flutterTts = FlutterTts();
  return _flutterTts;
});

final textToSpeechServiceProvider = Provider<TextToSpeechService>((ref) {
  final textToSpeech = ref.watch(textToSpeechProvider);
  final TextToSpeechService _textToSpeechService =
      TextToSpeechService(flutterTts: textToSpeech);

  return _textToSpeechService;
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  return _firestore;
});

final notesServiceProvider = Provider<NotesService>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final notesService = NotesService(firebaseFirestore: firestore);
  return notesService;
});

final notesNotifierProvider =
    StateNotifierProvider<NotesNotifier, NotesState>((ref) {
  final notesService = ref.watch(notesServiceProvider);
  final notesNotifier = NotesNotifier(notesService: notesService);
  return notesNotifier;
});

final todosServiceProvider = Provider<TodosService>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final todosService = TodosService(firebaseFirestore: firestore);
  return todosService;
});

final todosNotifierProvider =
    StateNotifierProvider<TodosNotifier, TodosState>(((ref) {
  final todosService = ref.watch(todosServiceProvider);
  final todosNotifier = TodosNotifier(todosService: todosService);
  return todosNotifier;
}));

final manipulateNoteNotifierProvider =
    StateNotifierProvider<ManipulateNoteNotifier, ManipulateNoteState>((ref) {
  final manipulateNoteNotifier = ManipulateNoteNotifier();
  return manipulateNoteNotifier;
});

final asistanceNotifierProvider =
    StateNotifierProvider<AsistanceNotifier, AsistanceState>((ref) {
  final notesService = ref.watch(notesServiceProvider);
  final todosService = ref.watch(todosServiceProvider);
  final speechToTextService = ref.watch(speechToTextServiceProvider);
  final textToSpeechService = ref.watch(textToSpeechServiceProvider);

  final asistanceNotifier = AsistanceNotifier(
    notesService: notesService,
    todosService: todosService,
    speechToTextService: speechToTextService,
    textToSpeechService: textToSpeechService,
  );

  return asistanceNotifier;
});
