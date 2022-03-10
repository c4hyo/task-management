import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:yo_task_managements/app/config/helper.dart';
import 'package:yo_task_managements/app/controllers/app_controller.dart';

import 'package:yo_task_managements/app/modules/todo/controllers/todo_controller.dart';

import '../../../config/collection.dart';
import '../../../config/theme.dart';
import '../../../data/models/note.dart';
import '../../../data/models/profile.dart';

class NotesView extends GetView<TodoController> {
  final myId = Get.find<AppController>().profileModel.uid;
  final description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: controller.todo.value.editor!.contains(myId),
        child: FloatingActionButton(
          onPressed: () {
            Get.dialog(
              Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Add Notes",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Card(
                        color: lightBackgroud,
                        elevation: 10,
                        shadowColor: secondaryColorAccent,
                        child: TextFormField(
                          maxLines: null,
                          controller: description,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(
                            color: primaryColor,
                          ),
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.only(left: 10, right: 10),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await taskCollection
                              .doc(controller.task.value.taskId)
                              .collection("todo")
                              .doc(controller.todo.value.id)
                              .collection("note")
                              .add({
                            "todo_id": controller.todo.value.id,
                            "task_id": controller.task.value.taskId,
                            "description": description.text,
                            "editor_id": myId,
                            "is_finished": false,
                            "created_at": DateTime.now().toIso8601String(),
                          });
                          description.clear();
                          Get.back();
                        },
                        child: Text("Add"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          child: Icon(Icons.note_alt_outlined),
        ),
      ),
      appBar: AppBar(
        title: Text('Notes View'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder<QuerySnapshot>(
            stream: taskCollection
                .doc(controller.task.value.taskId)
                .collection("todo")
                .doc(controller.todo.value.id)
                .collection("note")
                .orderBy("is_finished", descending: false)
                .orderBy("created_at", descending: true)
                .snapshots(),
            builder: (_, s) {
              if (!s.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: s.data!.docs.length,
                itemBuilder: (_, i) {
                  DocumentSnapshot doc = s.data!.docs[i];
                  NoteModel note = NoteModel.doc(doc);
                  return FutureBuilder<ProfileModel>(
                    future: profileCollection.doc(note.editorId).get().then(
                          (value) => ProfileModel.doc(value),
                        ),
                    builder: (_, snap) {
                      if (!snap.hasData) {
                        return Card(
                          child: ListTile(),
                        );
                      }
                      ProfileModel pm = snap.data!;
                      return _noteCard(note, pm, doc['created_at']);
                    },
                  );
                },
              );
            }),
      ),
    );
  }

  Widget _noteCard(NoteModel notes, ProfileModel profileModel, String dates) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border.all(
            color: secondaryColorAccent,
          ),
          color: notes.isFinished! ? greenUi : yellowUi,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  notes.description!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  profileModel.name!.capitalize!,
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                Text(
                  date(dates),
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Visibility(
              visible: controller.todo.value.editor!.contains(myId),
              child: Visibility(
                visible: !notes.isFinished!,
                child: IconButton(
                  onPressed: () async {
                    Get.bottomSheet(
                      Container(
                        color: lightBackgroud,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            ListTile(
                              title: Text("Finish"),
                              onTap: () async {
                                await taskCollection
                                    .doc(controller.task.value.taskId)
                                    .collection("todo")
                                    .doc(controller.todo.value.id)
                                    .collection("note")
                                    .doc(notes.noteId)
                                    .update(
                                  {"is_finished": true},
                                );
                                Get.back();
                              },
                            ),
                            ListTile(
                              title: Text("Delete"),
                              onTap: () async {
                                await taskCollection
                                    .doc(controller.task.value.taskId)
                                    .collection("todo")
                                    .doc(controller.todo.value.id)
                                    .collection("note")
                                    .doc(notes.noteId)
                                    .delete();
                                Get.back();
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.more_horiz_rounded,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
