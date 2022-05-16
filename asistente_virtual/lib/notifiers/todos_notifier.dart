import 'package:asistente_virtual/models/todo.dart';
import 'package:asistente_virtual/services/todo_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodosState extends Equatable {
  final List<Todo> todos;
  final bool isLoading;
  final bool isError;
  const TodosState({
    required this.todos,
    required this.isLoading,
    required this.isError,
  });

  TodosState copyWith({
    List<Todo>? todos,
    bool? isLoading,
    bool? isError,
  }) {
    return TodosState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
    );
  }

  @override
  String toString() =>
      'TodosState(todos: $todos, isLoading: $isLoading, isError: $isError)';

  @override
  List<Object> get props => [todos, isLoading, isError];
}

class TodosNotifier extends StateNotifier<TodosState> {
  final TodosService _todosService;

  TodosNotifier({required TodosService todosService})
      : _todosService = todosService,
        super(
          const TodosState(todos: [], isLoading: false, isError: false),
        ) {
    _todosService.todosStream().listen((todos) {
      state = state.copyWith(
        todos: todos,
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

  Future<void> addTodo({required String title}) async {
    state = state.copyWith(isLoading: true, isError: false);
    await _todosService.addTodo(title: title).catchError(
          (onError) =>
              {state = state.copyWith(isLoading: false, isError: true)},
        );
  }

  Future<void> removeTodo({required Todo todo}) async {
    state = state.copyWith(isLoading: true, isError: false);
    await _todosService.removeTodo(todo: todo).catchError(
          (onError) =>
              {state = state.copyWith(isLoading: false, isError: true)},
        );
  }

  Future<void> updateTodo({required Todo todo}) async {
    state = state.copyWith(isLoading: true, isError: false);
    await _todosService.updateTodo(todo: todo).catchError(
          (onError) =>
              {state = state.copyWith(isLoading: false, isError: true)},
        );
  }

  Future<void> checkTodo({required Todo todo}) async {
    state = state.copyWith(isLoading: true, isError: false);
    await _todosService.checkTodo(todo: todo).catchError(
          (onError) =>
              {state = state.copyWith(isLoading: false, isError: true)},
        );
  }
}
