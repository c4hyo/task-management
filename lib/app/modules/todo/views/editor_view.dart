import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:yo_task_managements/app/controllers/app_controller.dart';
import 'package:yo_task_managements/app/modules/todo/controllers/todo_controller.dart';

import '../../../config/collection.dart';
import '../../../data/models/profile.dart';
import '../../../widget/card_user.dart';

class EditorView extends GetView<TodoController> {
  final myId = Get.find<AppController>().profileModel.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: controller.task.value.ownerId == myId,
        child: FloatingActionButton(
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
                            visible: controller.task.value.ownerId == myId &&
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
                                  "editor":
                                      FieldValue.arrayUnion([snap.data!.uid])
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
            Icons.person_add_alt,
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Editor View'),
        centerTitle: true,
      ),
      body: Obx(
        () => ListView.builder(
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
                return Card(
                  elevation: 0.5,
                  child: ListTile(
                    leading: profilePicture(snap.data!.imageUrl),
                    title: Text(snap.data!.name!.capitalize!),
                    subtitle: Visibility(
                      visible: controller.todo.value.editor![i] ==
                          controller.task.value.ownerId,
                      child: Text("Owner"),
                    ),
                    trailing: Visibility(
                      visible: controller.task.value.ownerId == myId,
                      child: Visibility(
                        visible: controller.task.value.member![i] !=
                                controller.task.value.ownerId &&
                            controller.task.value.member!
                                .contains(controller.task.value.member![i]),
                        child: IconButton(
                          onPressed: () {
                            taskCollection
                                .doc(controller.task.value.taskId)
                                .collection("todo")
                                .where("editor",
                                    arrayContains:
                                        controller.task.value.member![i])
                                .get()
                                .then((value) {
                              if (value.docs.isNotEmpty) {
                                value.docs.forEach((element) {
                                  taskCollection
                                      .doc(controller.task.value.taskId)
                                      .collection("todo")
                                      .doc(element.id)
                                      .update({
                                    "editor": FieldValue.arrayRemove(
                                        [snap.data!.uid!])
                                  });
                                });
                              }
                            });
                            controller.todo.update((val) {
                              val!.editor!.removeWhere(
                                (element) =>
                                    element == controller.task.value.member![i],
                              );
                            });
                          },
                          icon: Icon(Icons.remove_circle_outline),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
