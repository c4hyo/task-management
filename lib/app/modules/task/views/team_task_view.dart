import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:yo_task_managements/app/controllers/app_controller.dart';
import 'package:yo_task_managements/app/modules/task/controllers/task_controller.dart';
import 'package:yo_task_managements/app/widget/card_user.dart';

import '../../../config/collection.dart';
import '../../../config/theme.dart';
import '../../../data/models/profile.dart';

class TeamTaskView extends GetView<TaskController> {
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
                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                color: lightBackgroud,
                child: ListView(
                  children: [
                    Center(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Text(
                          "Add team member",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: profileCollection
                          .doc(controller.task.value.ownerId)
                          .collection("friend")
                          .snapshots(),
                      builder: (_, snapshot) {
                        if (!snapshot.hasData) {
                          return ListTile();
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (_, i) {
                            DocumentSnapshot doc = snapshot.data!.docs[i];
                            return FutureBuilder<ProfileModel>(
                              future: profileCollection
                                  .doc(doc.id)
                                  .get()
                                  .then((value) => ProfileModel.doc(value)),
                              builder: (_, s) {
                                if (!s.hasData) {
                                  return ListTile();
                                }
                                ProfileModel pm = s.data!;
                                return ListTile(
                                  title: Text(pm.name!.capitalize!),
                                  subtitle: Visibility(
                                    visible: controller.task.value.member!
                                        .contains(pm.uid),
                                    child: Text("Team member"),
                                  ),
                                  trailing: Visibility(
                                    visible: !controller.task.value.member!
                                        .contains(pm.uid),
                                    child: IconButton(
                                      onPressed: () async {
                                        await taskCollection
                                            .doc(controller.task.value.taskId)
                                            .update({
                                          "member":
                                              FieldValue.arrayUnion([pm.uid])
                                        });
                                        controller.task.update((val) {
                                          val!.member!.add(pm.uid);
                                        });
                                        Get.back();
                                      },
                                      icon: Icon(
                                        Icons.add,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          child: Icon(
            Icons.person_add_alt_rounded,
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('Team Task View'),
        centerTitle: true,
      ),
      body: Obx(
        () => Padding(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
          child: ListView.builder(
            itemCount: controller.task.value.member!.length,
            itemBuilder: (_, i) {
              return FutureBuilder<ProfileModel>(
                future: profileCollection
                    .doc(controller.task.value.member![i])
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
                        visible: controller.task.value.member![i] ==
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
                            onPressed: () async {
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
                              controller.task.update((val) {
                                val!.member!.removeWhere((element) =>
                                    element ==
                                    controller.task.value.member![i]);
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
      ),
    );
  }
}
