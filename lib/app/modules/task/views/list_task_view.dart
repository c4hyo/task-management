import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:yo_task_managements/app/modules/task/bindings/task_binding.dart';
import 'package:yo_task_managements/app/modules/task/controllers/task_controller.dart';
import 'package:yo_task_managements/app/modules/task/views/detail_task_view.dart';

import '../../../config/collection.dart';
import '../../../controllers/app_controller.dart';
import '../../../data/models/task.dart';
import '../../home/views/card_home_view.dart';

class ListTaskView extends GetView<TaskController> {
  final app = Get.find<AppController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Task'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: taskCollection
                // .where("type", isEqualTo: "team")
                .where("member", arrayContains: app.profileModel.uid)
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
                  TaskModel tm = TaskModel.doc(doc);
                  return InkWell(
                    onTap: () {
                      Get.to(
                        () => DetailTaskView(),
                        binding: TaskBinding(),
                        arguments: {
                          "profile": app.profileModel,
                          "task": tm,
                        },
                      );
                    },
                    child: tm.type == "team"
                        ? cardTaskTeam(tm)
                        : cardTaskPersonal(tm),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
