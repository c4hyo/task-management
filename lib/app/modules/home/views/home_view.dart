import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:yo_task_managements/app/config/collection.dart';
import 'package:yo_task_managements/app/config/helper.dart';
import 'package:yo_task_managements/app/config/theme.dart';
import 'package:yo_task_managements/app/controllers/app_controller.dart';
import 'package:yo_task_managements/app/data/models/task.dart';
import 'package:yo_task_managements/app/modules/home/bindings/home_binding.dart';
import 'package:yo_task_managements/app/modules/home/views/card_home_view.dart';
import 'package:yo_task_managements/app/modules/home/views/home_date_view.dart';
import 'package:yo_task_managements/app/modules/task/bindings/task_binding.dart';
import 'package:yo_task_managements/app/modules/task/views/detail_task_view.dart';
import 'package:yo_task_managements/app/routes/app_pages.dart';
import 'package:yo_task_managements/app/widget/card_user.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final app = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
                child: Icon(LineariconsFree.user_1),
                label: "Search Friend",
                onTap: () =>
                    Get.toNamed(Routes.SEARCH, arguments: {"type": "friend"})),
            SpeedDialChild(
                child: Icon(LineariconsFree.enter),
                label: "Join task",
                onTap: () =>
                    Get.toNamed(Routes.SEARCH, arguments: {"type": "task"})),
            SpeedDialChild(
              child: Icon(LineariconsFree.pencil),
              label: "Add task",
              onTap: () => Get.toNamed(
                Routes.TASK,
                arguments: {"profile": app.profileModel},
              ),
            ),
          ],
        ),
        appBar: AppBar(
          title: Text(
            'Hi, ${app.profileModel.name}'.capitalize!,
            style: GoogleFonts.poppins(),
          ),
          centerTitle: false,
          actions: [
            InkWell(
              onTap: () {
                Get.toNamed(
                  Routes.PROFILE,
                  arguments: {"profile": app.profileModel},
                );
              },
              child: profilePicture(app.profileModel.imageUrl!),
            ),
            SizedBox(
              width: 15,
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    date(DateTime.now().toIso8601String()),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      fontSize: 18,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.timeline.value = <Appointment>[];
                      Get.to(
                        () => HomeDateView(),
                        binding: HomeBinding(),
                        transition: Transition.rightToLeftWithFade,
                      );
                    },
                    child: Text("View events"),
                  ),
                ],
              ),
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
        ),
      ),
    );
  }
}
