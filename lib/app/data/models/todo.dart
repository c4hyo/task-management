import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  String? id;
  String? taskId;
  String? title;
  String? description;
  String? startDate;
  String? endDate;
  String? status;
  List<dynamic>? editor;
  TodoModel({
    this.id,
    this.taskId,
    this.title,
    this.description,
    this.endDate,
    this.startDate,
    this.status,
    this.editor,
  });
  TodoModel.doc(DocumentSnapshot doc) {
    // digunakan untuk memecah data dari firestore menjadi sebuah variabel yang mudah digunakan
    id = doc.id;
    taskId = doc['task_id'];
    title = doc['title'];
    description = doc['description'];
    endDate = doc['end_date'];
    startDate = doc['start_date'];
    status = doc['status'];
    editor = doc['editor'];
  }
}
