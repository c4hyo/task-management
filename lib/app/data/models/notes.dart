import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class NotesModel {
  String? notesId;
  String? title;
  String? description;
  String? color;
  String? ownerId;
  String? createdAt;
  NotesModel({
    this.notesId,
    this.title,
    this.description,
    this.color,
    this.ownerId,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'notesId': notesId,
      'title': title,
      'description': description,
      'color': color,
      'ownerId': ownerId,
      'createdAt': createdAt,
    };
  }

  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
      notesId: map['notesId'],
      title: map['title'],
      description: map['description'],
      color: map['color'],
      ownerId: map['ownerId'],
      createdAt: map['createdAt'],
    );
  }

  NotesModel.doc(DocumentSnapshot doc) {
    notesId = doc.id;
    title = doc['title'];
    description = doc['description'];
    color = doc['color'];
    ownerId = doc['ownerId'];
    createdAt = doc['createdAt'];
  }

  String toJson() => json.encode(toMap());

  factory NotesModel.fromJson(String source) =>
      NotesModel.fromMap(json.decode(source));
}
