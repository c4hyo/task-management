import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:yo_task_managements/app/controllers/app_controller.dart';
import 'package:yo_task_managements/app/data/models/note.dart';
import 'package:yo_task_managements/app/modules/todo/bindings/todo_binding.dart';
import 'package:yo_task_managements/app/modules/todo/controllers/todo_controller.dart';
import 'package:yo_task_managements/app/modules/todo/views/setting_todo_view.dart';

import '../../../config/collection.dart';
import '../../../config/helper.dart';
import '../../../config/theme.dart';
import '../../../data/models/profile.dart';

class DetailTodoView extends GetView<TodoController> {
  final myId = Get.find<AppController>().profileModel.uid;
  final description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(
        () => Visibility(
          visible: controller.task.value.ownerId == myId ||
              controller.todo.value.editor!.contains(myId),
          child: controller.isNote.isTrue
              ? FloatingActionButton(
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
                                    "created_at":
                                        DateTime.now().toIso8601String(),
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
                  child: Icon(
                    Icons.add_comment_outlined,
                  ),
                )
              : FloatingActionButton(
                  onPressed: () {
                    Get.bottomSheet(
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
                        color: Get.theme.scaffoldBackgroundColor,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.task.value.member!.length,
                          itemBuilder: (_, i) {
                            return FutureBuilder<ProfileModel>(
                              future: profileCollection
                                  .doc(controller.task.value.member![i])
                                  .get()
                                  .then((value) => ProfileModel.doc(value)),
                              builder: (_, snap) {
                                if (!snap.hasData) {
                                  return ListTile(
                                    title: Text(""),
                                  );
                                }
                                return ListTile(
                                  title: Text(snap.data!.name!.capitalize!),
                                  subtitle: Visibility(
                                    visible: controller.cekEditor(
                                        controller.task.value.member![i],
                                        controller.todo.value),
                                    child: Text("Already editor"),
                                  ),
                                  trailing: Visibility(
                                    visible: controller.task.value.ownerId ==
                                            myId &&
                                        !controller.cekEditor(
                                            controller.task.value.member![i],
                                            controller.todo.value),
                                    child: IconButton(
                                      onPressed: () {
                                        taskCollection
                                            .doc(controller.task.value.taskId)
                                            .collection("todo")
                                            .doc(controller.todo.value.id)
                                            .update({
                                          "editor": FieldValue.arrayUnion(
                                              [snap.data!.uid])
                                        });
                                        controller.todo.update((val) {
                                          val!.editor!.add(snap.data!.uid);
                                        });
                                        Get.back();
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.person_add_alt_1_outlined,
                  ),
                ),
        ),
      ),
      appBar: AppBar(
        title: Text(''),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                () => SettingTodoView(),
                arguments: {
                  "task": controller.task.value,
                  "todo": controller.todo.value
                },
                binding: TodoBinding(),
              );
            },
            icon: Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: Obx(
          () => ListView(
            children: [
              Text(
                controller.todo.value.title!.capitalize!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Description : ",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                controller.todo.value.description!,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: darkText,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: greenUi,
                        child: Icon(
                          Icons.date_range_outlined,
                          color: darkText,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Start Date"),
                          Text(
                            date(controller.todo.value.startDate),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: redUi,
                        child: Icon(
                          Icons.date_range_outlined,
                          color: darkText,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Deadline"),
                          Text(
                            date(
                              controller.todo.value.endDate,
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      if (controller.isNote.isFalse) {
                        controller.isNote.toggle();
                      }
                    },
                    child: Container(
                      width: Get.size.width / 2.5,
                      child: Column(
                        children: [
                          Text(
                            "Notes",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: Get.size.width / 5,
                            height: 3,
                            color: controller.isNote.isTrue
                                ? primaryColor
                                : secondaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (controller.isNote.isTrue) {
                        controller.isNote.toggle();
                      }
                    },
                    child: Container(
                      width: Get.size.width / 2.5,
                      child: Column(
                        children: [
                          Text(
                            "Editor",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: Get.size.width / 5,
                            height: 3,
                            color: controller.isNote.isFalse
                                ? primaryColor
                                : secondaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              controller.isNote.isTrue ? _notes() : _editor(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notes() {
    return StreamBuilder<QuerySnapshot>(
        stream: taskCollection
            .doc(controller.task.value.taskId)
            .collection("todo")
            .doc(controller.todo.value.id)
            .collection("note")
            .orderBy("created_at", descending: true)
            .snapshots(),
        builder: (_, s) {
          if (!s.hasData) {
            return ListTile();
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
                    return ListTile();
                  }
                  ProfileModel pm = snap.data!;
                  return Card(
                    color: colorNote(note.isFinished!),
                    child: ListTile(
                      title: Text(pm.name!.capitalize!),
                      subtitle: Text(note.description!.capitalizeFirst!),
                      trailing: Visibility(
                        visible: !note.isFinished!,
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
                                            .doc(note.noteId)
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
                                            .doc(note.noteId)
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
                            Icons.more_horiz,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        });
  }

  Widget _editor() {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: controller.todo.value.editor!.length,
      itemBuilder: (_, i) {
        return FutureBuilder<ProfileModel>(
          future: profileCollection
              .doc(controller.todo.value.editor![i])
              .get()
              .then((value) => ProfileModel.doc(value)),
          builder: (_, snap) {
            if (!snap.hasData) {
              return ListTile();
            }
            return ListTile(
              title: Text(snap.data!.name!.capitalize!),
              subtitle: Visibility(
                visible: controller.todo.value.editor![i] ==
                    controller.task.value.ownerId,
                child: Text("Owner"),
              ),
            );
          },
        );
      },
    );
  }
}
