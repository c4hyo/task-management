import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String? taskId;
  String? title;
  String? startDate;
  String? endDate;
  String? type;
  String? code;
  String? color;
  String? ownerId;
  List<dynamic>? member;
  String? createdAt;
  String? description;
  String? category;
  int? todoCount;
  int? todoFinish;

  TaskModel({
    this.taskId,
    this.title,
    this.startDate,
    this.endDate,
    this.type,
    this.code,
    this.member,
    this.color,
    this.ownerId,
    this.createdAt,
    this.description,
    this.category,
    this.todoCount,
    this.todoFinish,
  });

  TaskModel.doc(DocumentSnapshot doc) {
    // digunakan untuk memecah data dari firestore menjadi sebuah variabel yang mudah digunakan
    taskId = doc.id;
    title = doc['title'];
    startDate = doc['start_date'];
    endDate = doc['end_date'];
    member = doc['member'];
    type = doc['type'];
    code = doc['code'];
    color = doc['color'];
    ownerId = doc['owner_id'];
    createdAt = doc['created_at'];
    description = doc["description"];
    category = doc['category'];
    todoCount = doc['todo_count'];
    todoFinish = doc['todo_finish'];
  }
}

class CategoryModel {
  String? id;
  String? category;
  CategoryModel({
    this.id,
    this.category,
  });

  CategoryModel.doc(DocumentSnapshot doc) {
    // digunakan untuk memecah data dari firestore menjadi sebuah variabel yang mudah digunakan
    id = doc.id;
    category = doc['category'];
  }
}
