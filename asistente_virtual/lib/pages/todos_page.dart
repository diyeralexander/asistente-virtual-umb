import 'package:asistente_virtual/dependency_injection/dependency_injection.dart';
import 'package:asistente_virtual/pages/add_todo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodosPage extends ConsumerStatefulWidget {
  const TodosPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RemindersPageState();
}

class _RemindersPageState extends ConsumerState<TodosPage> {
  @override
  Widget build(BuildContext context) {
    final todoState = ref.watch(todosNotifierProvider);

    return Scaffold(
      body: todoState.todos.isEmpty
          ? const Center(
              child: Text('No hay tareas'),
            )
          : ListView.builder(
              itemCount: todoState.todos.length,
              itemBuilder: (context, index) {
                final todo = todoState.todos[index];
                return ListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration:
                          todo.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => ref
                        .read(todosNotifierProvider.notifier)
                        .removeTodo(todo: todo),
                  ),
                  leading: Checkbox(
                    value: todo.isDone,
                    onChanged: (value) => ref
                        .read(todosNotifierProvider.notifier)
                        .checkTodo(todo: todo),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addTodoFloatingActionButton',
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const AddTodoPage(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
