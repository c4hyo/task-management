import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:yo_task_managements/app/controllers/bottom_navigation_controller.dart';
import 'package:yo_task_managements/app/modules/task/bindings/task_binding.dart';
import 'package:yo_task_managements/app/modules/task/controllers/task_controller.dart';
import 'package:yo_task_managements/app/modules/task/views/detail_task_view.dart';

import '../../../config/collection.dart';
import '../../../config/theme.dart';
import '../../../controllers/app_controller.dart';
import '../../../data/models/task.dart';
import '../../../routes/app_pages.dart';
import '../../../widget/card_user.dart';
import '../../home/views/card_home_view.dart';

class ListTaskView extends GetView<TaskController> {
  final app = Get.find<AppController>();
  final btm = Get.find<BottomNavigationController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.flip,
        backgroundColor: primaryColor,
        height: Get.size.height * 0.075,
        color: lightBackgroud,
        activeColor: lightBackgroud,
        items: [
          TabItem(
            icon: Icon(
              Icons.calendar_today,
              color: lightBackgroud,
            ),
            title: "Events",
          ),
          TabItem(
            icon: Icon(
              Icons.task,
              color: lightBackgroud,
            ),
            title: "Task",
          ),
          TabItem(
            icon: Icon(
              Icons.home,
              color: lightBackgroud,
            ),
            title: "Home",
          ),
          TabItem(
            icon: Icon(
              Icons.note,
              color: lightBackgroud,
            ),
            title: "Note",
          ),
          TabItem(
            icon: profilePicture(app.profileModel.imageUrl),
            title: "Profile",
          ),
        ],
        initialActiveIndex: btm.initialPage.value,
        onTap: (int i) => btm.changePage(i, app.profileModel),
      ),
      appBar: AppBar(
        title: Text('All Task'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(
                Routes.TASK,
                arguments: {"profile": app.profileModel},
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
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
