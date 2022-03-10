import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  // data model dari note
  String? noteId;
  String? todoId;
  String? taskId;
  String? description;
  String? editorId;
  bool? isFinished;
  NoteModel({
    this.noteId,
    this.todoId,
    this.taskId,
    this.description,
    this.editorId,
    this.isFinished,
  });
  // digunakan untuk memecah data dari firestore menjadi sebuah variabel yang mudah digunakan
  NoteModel.doc(DocumentSnapshot doc) {
    noteId = doc.id;
    todoId = doc['todo_id'];
    taskId = doc['task_id'];
    description = doc['description'];
    editorId = doc['editor_id'];
    isFinished = doc['is_finished'];
  }
}
