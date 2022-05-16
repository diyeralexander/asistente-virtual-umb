import 'package:asistente_virtual/models/todo.dart';
import 'package:asistente_virtual/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodosService {
  final FirebaseFirestore _firestore;

  TodosService({required FirebaseFirestore firebaseFirestore})
      : _firestore = FirebaseFirestore.instance;

  Future<void> addTodo({required String title}) async {
    final todo = Todo(
      title: title,
    );
    await _firestore.collection(pathTodos).add(todo.toMap());
  }

  Future<void> removeTodo({required Todo todo}) async {
    await _firestore
        .collection(pathTodos)
        .where('id', isEqualTo: todo.id)
        .get()
        .then((value) {
      value.docs.first.reference.delete();
    });
  }

  Future<void> updateTodo({required Todo todo}) async {
    await _firestore
        .collection(pathTodos)
        .where('id', isEqualTo: todo.id)
        .get()
        .then((value) {
      value.docs.first.reference.update(todo.toMap());
    });
  }

  Future<void> checkTodo({required Todo todo}) async {
    await _firestore
        .collection(pathTodos)
        .where('id', isEqualTo: todo.id)
        .get()
        .then((value) {
      value.docs.first.reference.update({
        'isDone': !todo.isDone,
      });
    });
  }

  Stream<List<Todo>> todosStream() {
    return _firestore.collection(pathTodos).snapshots().map(
          (event) => event.docs
              .map(
                (doc) => Todo.fromMap(
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future<List<Todo>> todosList() async {
    return _firestore.collection(pathTodos).get().then(
        (value) => value.docs.map((doc) => Todo.fromMap(doc.data())).toList());
  }
}
