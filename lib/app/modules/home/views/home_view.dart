import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:yo_task_managements/app/config/collection.dart';
import 'package:yo_task_managements/app/config/theme.dart';
import 'package:yo_task_managements/app/controllers/app_controller.dart';
import 'package:yo_task_managements/app/controllers/bottom_navigation_controller.dart';
import 'package:yo_task_managements/app/data/models/task.dart';
import 'package:yo_task_managements/app/modules/home/bindings/home_binding.dart';
import 'package:yo_task_managements/app/modules/home/views/card_home_view.dart';
import 'package:yo_task_managements/app/modules/home/views/home_date_view.dart';
import 'package:yo_task_managements/app/modules/task/bindings/task_binding.dart';
import 'package:yo_task_managements/app/modules/task/views/detail_task_view.dart';
import 'package:yo_task_managements/app/modules/task/views/list_task_view.dart';
import 'package:yo_task_managements/app/routes/app_pages.dart';
import 'package:yo_task_managements/app/widget/card_user.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final app = Get.find<AppController>();
  final btm = Get.find<BottomNavigationController>();

  @override
  Widget build(BuildContext context) {
    controller.notesCount.bindStream(
      controller.getCountNotes(app.profileModel.uid!),
    );
    controller.taskCount.bindStream(
      controller.getTaskCount(app.profileModel.uid!),
    );
    return Obx(
      () => Scaffold(
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
        floatingActionButton: SpeedDial(
          direction: SpeedDialDirection.down,
          backgroundColor: lightBackgroud,
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(
            color: primaryColor,
          ),
          children: [
            SpeedDialChild(
              child: Icon(LineariconsFree.enter),
              label: "Join task",
              onTap: () => Get.toNamed(
                Routes.SEARCH,
                arguments: {"type": "task"},
              ),
            ),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(
            'Hi, ',
            style: GoogleFonts.poppins(
              color: lightBackgroud,
            ),
          ),
          centerTitle: false,
        ),
        body: ListView(
          children: [
            Container(
              color: lightBackgroud,
              height: Get.size.height * 0.4,
              width: Get.size.width,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.elliptical(
                          Get.size.width / 1.5,
                          Get.size.height * 0.075,
                        ),
                        bottomRight: Radius.elliptical(
                          Get.size.width / 1.5,
                          Get.size.height * 0.075,
                        ),
                      ),
                    ),
                    height: Get.size.height * 0.35,
                    width: Get.size.width,
                  ),
                  Container(
                    height: Get.size.height * 0.25,
                    width: double.infinity,
                    color: primaryColor,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          app.profileModel.name!.capitalize!,
                          style: TextStyle(
                            color: lightBackgroud,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Center(
                          child: ElevatedButton(
                            style: bs,
                            onPressed: () {
                              controller.timeline.value = <Appointment>[];
                              Get.to(
                                () => HomeDateView(),
                                binding: HomeBinding(),
                                transition: Transition.fadeIn,
                              );
                            },
                            child: Text(
                              "Calendar Task",
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                        ),
                        Text(""),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: Get.size.height * 0.25,
                        width: Get.size.width * 0.9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: Get.size.height * 0.2,
                              width: Get.size.height * 0.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 0.2,
                                    color: secondaryColor,
                                    offset: Offset(4, 2),
                                  ),
                                ],
                                color: lightBackgroud,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Task"),
                                  Text(
                                    controller.taskCount.value.toString(),
                                    style: TextStyle(
                                      fontSize: Get.height * 0.075,
                                    ),
                                  ),
                                  Text("View all"),
                                ],
                              ),
                            ),
                            Container(
                              height: Get.size.height * 0.2,
                              width: Get.size.height * 0.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 0.2,
                                    color: secondaryColor,
                                    offset: Offset(4, 2),
                                  ),
                                ],
                                color: lightBackgroud,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Notes"),
                                  Text(
                                    controller.notesCount.value.toString(),
                                    style: TextStyle(
                                      fontSize: Get.height * 0.075,
                                    ),
                                  ),
                                  Text("View all"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recent task",
                    style: TextStyle(
                      color: darkText,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
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
                  itemCount:
                      (s.data!.docs.length < 3) ? s.data!.docs.length : 3,
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
    );
  }
}
