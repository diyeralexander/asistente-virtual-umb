import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Note extends Equatable {
  final String id;
  final DateTime createDate;
  final String title;
  final String content;

  Note({
    String? id,
    DateTime? createDate,
    required this.title,
    required this.content,
  })  : id = id ?? const Uuid().v4(),
        createDate = createDate ?? DateTime.now();

  Note copyWith({
    String? id,
    DateTime? createDate,
    String? title,
    String? content,
  }) {
    return Note(
      id: id ?? this.id,
      createDate: createDate ?? this.createDate,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createDate': Timestamp.fromDate(createDate),
      'title': title,
      'content': content,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] ?? '',
      createDate: (map['createDate'] as Timestamp).toDate(),
      title: map['title'] ?? '',
      content: map['content'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Note(id: $id, createDate: $createDate, title: $title, content: $content)';
  }

  @override
  List<Object> get props => [id, createDate, title, content];
}
