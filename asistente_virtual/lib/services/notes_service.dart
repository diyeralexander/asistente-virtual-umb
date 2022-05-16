import 'dart:async';

import 'package:asistente_virtual/models/note.dart';
import 'package:asistente_virtual/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotesService {
  final FirebaseFirestore _firestore;

  NotesService({required FirebaseFirestore firebaseFirestore})
      : _firestore = FirebaseFirestore.instance;

  Future<void> addNote({required String title, required String content}) async {
    final note = Note(title: title, content: content);
    await _firestore.collection(pathNotes).add(note.toMap());
  }

  Future<void> removeNote({required Note note}) async {
    await _firestore
        .collection(pathNotes)
        .where('id', isEqualTo: note.id)
        .get()
        .then((value) {
      value.docs.first.reference.delete();
    });
  }

  Future<void> updateNote({required Note note}) async {
    await _firestore
        .collection(pathNotes)
        .where('id', isEqualTo: note.id)
        .get()
        .then((value) {
      value.docs.first.reference.update(note.toMap());
    });
  }

  Stream<List<Note>> notesStream() {
    return _firestore.collection(pathNotes).snapshots().map(
          (event) => event.docs
              .map(
                (doc) => Note.fromMap(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future<List<Note>> notesList() async {
    return _firestore.collection(pathNotes).get().then((value) => value.docs
        .map(
          (doc) => Note.fromMap(
            doc.data(),
          ),
        )
        .toList());
  }
}
