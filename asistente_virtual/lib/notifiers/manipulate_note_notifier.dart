import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManipulateNoteState extends Equatable {
  final String title;
  final String content;

  const ManipulateNoteState({
    this.title = '',
    this.content = '',
  });

  ManipulateNoteState copyWith({
    String? title,
    String? content,
  }) {
    return ManipulateNoteState(
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  @override
  String toString() => 'ManipulateNoteState(title: $title, content: $content)';

  @override
  List<Object> get props => [title, content];
}

class ManipulateNoteNotifier extends StateNotifier<ManipulateNoteState> {
  ManipulateNoteNotifier() : super(const ManipulateNoteState());

  bool get isValid {
    return state.title.isNotEmpty && state.content.isNotEmpty;
  }

  void updateTitle(String title) => state = state.copyWith(title: title);

  void updateContent(String content) =>
      state = state.copyWith(content: content);

  void clear() => state = const ManipulateNoteState();
}
