import 'package:asistente_virtual/models/note.dart';
import 'package:asistente_virtual/services/notes_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesState extends Equatable {
  final List<Note> notes;
  final bool isLoading;
  final bool isError;

  const NotesState({
    required this.notes,
    required this.isLoading,
    required this.isError,
  });

  NotesState copyWith({
    List<Note>? notes,
    bool? isLoading,
    bool? isError,
  }) {
    return NotesState(
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
    );
  }

  @override
  String toString() =>
      'NotesState(notes: $notes, isLoading: $isLoading, isError: $isError)';

  @override
  List<Object> get props => [notes, isLoading, isError];
}

class NotesNotifier extends StateNotifier<NotesState> {
  final NotesService _notesService;

  NotesNotifier({required NotesService notesService})
      : _notesService = notesService,
        super(const NotesState(
          notes: [],
          isLoading: false,
          isError: false,
        )) {
    _notesService.notesStream().listen((notes) {
      state = state.copyWith(
        notes: notes,
        isLoading: false,
        isError: false,
      );
    }, onError: (error) {
      state = state.copyWith(
        isLoading: false,
        isError: true,
      );
    });
  }

  List<Note> get notes => state.notes;

  Future<void> addNote({required String title, required String content}) async {
    state = state.copyWith(isLoading: true, isError: false);
    await _notesService.addNote(title: title, content: content).catchError(
          (onError) => state = state.copyWith(isLoading: false, isError: true),
        );
  }

  Future<void> removeNote({required Note note}) async {
    state = state.copyWith(isLoading: true, isError: false);
    await _notesService.removeNote(note: note).catchError(
          (onError) => state = state.copyWith(isLoading: false, isError: true),
        );
  }

  Future<void> updateNote({required Note note}) async {
    state = state.copyWith(isLoading: true, isError: false);
    await _notesService.updateNote(note: note).catchError(
          (onError) => state = state.copyWith(isLoading: false, isError: true),
        );
  }
}
