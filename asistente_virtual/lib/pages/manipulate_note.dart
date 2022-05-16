import 'package:asistente_virtual/dependency_injection/dependency_injection.dart';
import 'package:asistente_virtual/models/note.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManipulateNotePage extends ConsumerWidget {
  final Note? note;

  ManipulateNotePage({Key? key, this.note}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    initialValue: note?.title,
                    decoration: const InputDecoration(labelText: 'Title'),
                    onSaved: (value) => ref
                        .read(manipulateNoteNotifierProvider.notifier)
                        .updateTitle(value ?? ''),
                    validator: (value) {
                      if (value == null) {
                        return 'Title is required';
                      }
                      if (value.isEmpty) {
                        return 'Title is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: note?.content,
                    decoration: const InputDecoration(labelText: 'Content'),
                    onSaved: (value) => ref
                        .read(manipulateNoteNotifierProvider.notifier)
                        .updateContent(value ?? ''),
                    validator: (value) {
                      if (value == null) {
                        return 'Content is required';
                      }
                      if (value.isEmpty) {
                        return 'Content is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () {
                      _formKey.currentState?.save();

                      if (_formKey.currentState?.validate() ?? false) {
                        late Note newNote;
                        if (note == null) {
                          ref
                              .read(notesNotifierProvider.notifier)
                              .addNote(
                                  title: ref
                                      .read(manipulateNoteNotifierProvider)
                                      .title,
                                  content: ref
                                      .read(manipulateNoteNotifierProvider)
                                      .content)
                              .then((value) => context.router.pop())
                              .catchError((onError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error al añadir la nota'),
                              ),
                            );
                          });
                        } else {
                          newNote = note!.copyWith(
                              title: ref
                                  .read(manipulateNoteNotifierProvider)
                                  .title,
                              content: ref
                                  .read(manipulateNoteNotifierProvider)
                                  .content);

                          ref
                              .read(notesNotifierProvider.notifier)
                              .updateNote(note: newNote)
                              .then((value) => context.router.pop())
                              .catchError((onError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Error al añadir la nota'),
                              ),
                            );
                          });
                        }
                      }
                    },
                    child: const Text('Guardar'),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
