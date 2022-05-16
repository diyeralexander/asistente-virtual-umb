import 'package:asistente_virtual/dependency_injection/dependency_injection.dart';
import 'package:asistente_virtual/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  @override
  Widget build(BuildContext context) {
    final listNotes =
        ref.watch(notesNotifierProvider.select((value) => value.notes));
    return Scaffold(
      body: listNotes.isEmpty
          ? const Center(
              child: Text('No hay notas'),
            )
          : ListView.builder(
              itemCount: listNotes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(listNotes[index].title),
                  subtitle: Text(listNotes[index].content),
                  trailing: IconButton(
                    onPressed: () => ref
                        .read(notesNotifierProvider.notifier)
                        .removeNote(note: listNotes[index]),
                    icon: const Icon(Icons.delete),
                  ),
                  leading: IconButton(
                    onPressed: () => context.router.navigate(
                      ManipulateNoteRoute(
                        note: listNotes[index],
                      ),
                    ),
                    icon: const Icon(Icons.edit),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'addNoteFloatingActionButton',
        onPressed: () => context.router.navigate(
          ManipulateNoteRoute(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
