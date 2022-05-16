import 'package:asistente_virtual/dependency_injection/dependency_injection.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTodoPage extends ConsumerStatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends ConsumerState<AddTodoPage> {
  String title = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Añadir tarea'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          autofocus: true,
          autovalidateMode: AutovalidateMode.always,
          decoration: const InputDecoration(
            hintText: '¿Qué se tiene que hacer?',
          ),
          validator: (value) {
            if (value == null) {
              return 'Este campo es obligatorio';
            }

            if (value.isEmpty) {
              return 'Escribe una tarea';
            }
            return null;
          },
          onChanged: (value) {
            if (value.isNotEmpty) {
              setState(() {
                title = value;
              });
            }
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => context.router.pop(),
        ),
        TextButton(
          child: const Text('Añadir'),
          onPressed: () async {
            _formKey.currentState?.save();

            if (_formKey.currentState?.validate() ?? false) {
              await ref
                  .read(todosNotifierProvider.notifier)
                  .addTodo(title: title)
                  .whenComplete(() => context.router.pop())
                  .catchError(
                    (onError) => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al añaadir la tarea'),
                      ),
                    ),
                  );
            }
          },
        ),
      ],
    );
  }
}
