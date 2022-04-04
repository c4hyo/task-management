import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:yo_task_managements/app/config/helper.dart';
import 'package:yo_task_managements/app/config/theme.dart';

import 'package:yo_task_managements/app/data/models/todo.dart';
import 'package:yo_task_managements/app/modules/task/bindings/task_binding.dart';
import 'package:yo_task_managements/app/modules/task/controllers/task_controller.dart';
import 'package:yo_task_managements/app/modules/task/views/card_todo_view.dart';
import 'package:yo_task_managements/app/modules/task/views/setting_task_view.dart';
import 'package:yo_task_managements/app/modules/task/views/team_task_view.dart';
import 'package:yo_task_managements/app/routes/app_pages.dart';
import 'package:yo_task_managements/app/widget/icon_badge.dart';

import '../../home/views/home_date_view.dart';

class DetailTaskView extends GetView<TaskController> {
  @override
  Widget build(BuildContext context) {
    controller.getlistTodo(controller.task.value.taskId!);
    return Obx(
      () => Scaffold(
        floatingActionButton: Visibility(
          visible: controller.isTask.isTrue,
          child: FloatingActionButton(
            onPressed: () {
              Get.toNamed(Routes.TODO,
                  arguments: {"task": controller.task.value});
            },
            child: Icon(
              Icons.add_comment_outlined,
            ),
          ),
        ),
        appBar: AppBar(
          actions: [
            Visibility(
              visible: controller.task.value.type == "team",
              child: BadgeIcons(
                count: controller.task.value.member!.length,
                icon: Icons.people_alt_outlined,
                onTap: () {
                  Get.to(
                    TeamTaskView(),
                    arguments: {"task": controller.task.value},
                    binding: TaskBinding(),
                  );
                },
                isZero: controller.task.value.member!.isEmpty,
              ),
            ),
            Visibility(
              visible:
                  controller.task.value.ownerId == controller.profileTask!.uid,
              child: IconButton(
                onPressed: () {
                  Get.to(
                    () => SettingTaskView(),
                    arguments: {"task": controller.task.value},
                    binding: TaskBinding(),
                  );
                },
                icon: Icon(
                  Icons.settings_outlined,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
          child: ListView(
            children: [
              Text(
                controller.task.value.title!.capitalize!,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              GestureDetector(
                onTap: () => controller.showCode.toggle(),
                child: Text(
                  controller.showCode.isTrue
                      ? "Code : ${controller.task.value.code}"
                      : "Code : **********",
                  style: TextStyle(
                    color: darkText,
                  ),
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
                controller.task.value.description!,
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
                            date(controller.task.value.startDate),
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
                              controller.task.value.endDate,
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
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      if (controller.isTask.isFalse) {
                        controller.isTask.toggle();
                      }
                    },
                    child: Container(
                      width: Get.size.width / 2.5,
                      child: Column(
                        children: [
                          Text(
                            "To Do",
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
                            color: controller.isTask.isTrue
                                ? primaryColor
                                : secondaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (controller.isTask.isTrue) {
                        controller.isTask.toggle();
                      }
                    },
                    child: Container(
                      width: Get.size.width / 2.5,
                      child: Column(
                        children: [
                          Text(
                            "Event",
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
                              color: controller.isTask.isFalse
                                  ? primaryColor
                                  : secondaryColor),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Visibility(
                visible: controller.isTask.isTrue,
                child: ListTile(
                  onTap: () {
                    Get.bottomSheet(
                      Container(
                        color: lightBackgroud,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text("All"),
                              onTap: () {
                                controller.todoData.value = "all";
                                Get.back();
                              },
                            ),
                            ListTile(
                              title: Text("Finish"),
                              onTap: () {
                                controller.todoData.value = "finish";
                                Get.back();
                              },
                            ),
                            ListTile(
                              title: Text("Unfinished"),
                              onTap: () {
                                controller.todoData.value = "unfinish";
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
                  title: Text(controller.todoData.value.capitalize!),
                  trailing: Icon(
                    Icons.arrow_drop_down,
                  ),
                ),
              ),
              controller.isTask.isTrue ? _todo() : _event(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _todo() {
    return StreamBuilder<QuerySnapshot>(
      stream: controller.getTodo(
        controller.todoData.value,
        taskId: controller.task.value.taskId,
      ),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          primary: false,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (_, i) {
            DocumentSnapshot doc = snapshot.data!.docs[i];
            TodoModel todoModel = TodoModel.doc(doc);
            return cardTodoView(
              todoModel,
              controller.profileTask!,
              controller.task.value,
            );
          },
        );
      },
    );
  }

  Widget _event() {
    return Container(
      width: Get.size.width,
      height: Get.size.height / 2,
      child: SfCalendar(
        headerStyle: CalendarHeaderStyle(
          textAlign: TextAlign.center,
          backgroundColor: lightBackgroud,
          textStyle: TextStyle(
            fontSize: 25,
            fontStyle: FontStyle.normal,
            letterSpacing: 5,
            color: primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        view: CalendarView.schedule,
        scheduleViewSettings: ScheduleViewSettings(
          appointmentItemHeight: 70,
          appointmentTextStyle: TextStyle(
            color: lightText,
          ),
        ),
        initialDisplayDate: DateTime.now(),
        initialSelectedDate: DateTime.now(),
        firstDayOfWeek: 6,
        dataSource: Timeline(
          _listTodo(controller.listTodo),
        ),
      ),
    );
  }

  List<Appointment> _listTodo(List<Appointment> resource) {
    final data = <Appointment>[];
    resource.forEach((element) {
      data.add(element);
    });
    return data;
  }
}
