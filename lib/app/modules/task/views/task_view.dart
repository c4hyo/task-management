import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:yo_task_managements/app/config/collection.dart';
import 'package:yo_task_managements/app/config/helper.dart';
import 'package:yo_task_managements/app/config/theme.dart';
import 'package:yo_task_managements/app/data/models/task.dart';
import 'package:yo_task_managements/app/modules/home/controllers/home_controller.dart';
import 'package:yo_task_managements/app/modules/home/views/home_view.dart';

import '../controllers/task_controller.dart';

class TaskView extends GetView<TaskController> {
  final title = TextEditingController();
  final category = TextEditingController();
  final endDate = TextEditingController();
  final startDate = TextEditingController();
  final type = TextEditingController();
  final color = TextEditingController();
  final description = TextEditingController();
  final home = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Task'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                TaskModel tm = TaskModel(
                  category: category.text,
                  code: randomString(),
                  color: color.text,
                  createdAt: "",
                  description: description.text,
                  endDate: controller.tempEndDate.value,
                  member: [controller.profileTask!.uid],
                  ownerId: controller.profileTask!.uid,
                  startDate: controller.tempStartDate.value,
                  title: title.text,
                  type: type.text,
                );
                controller.addtask(tm);

                Get.back();
              },
              icon: Icon(Icons.check_outlined),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
          child: ListView(
            children: [
              ListTile(
                title: Text(
                  "Task title",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Card(
                  color: lightBackgroud,
                  elevation: 10,
                  shadowColor: secondaryColorAccent,
                  child: TextFormField(
                    controller: title,
                    style: TextStyle(
                      color: primaryColor,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "Category",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Card(
                  color: lightBackgroud,
                  elevation: 10,
                  shadowColor: secondaryColorAccent,
                  child: TextFormField(
                    onTap: () {
                      Get.bottomSheet(
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
                          color: Get.theme.scaffoldBackgroundColor,
                          child: FutureBuilder<QuerySnapshot>(
                            future:
                                categoryCollection.orderBy("category").get(),
                            builder: (_, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (_, i) {
                                  DocumentSnapshot doc = snapshot.data!.docs[i];
                                  CategoryModel cm = CategoryModel.doc(doc);
                                  return ListTile(
                                    onTap: () {
                                      category.text = cm.category!;
                                      Get.back();
                                    },
                                    title: Text("${cm.category}".capitalize!),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                    readOnly: true,
                    controller: category,
                    style: TextStyle(
                      color: primaryColor,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "Start Date",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Card(
                  color: lightBackgroud,
                  elevation: 10,
                  shadowColor: secondaryColorAccent,
                  child: TextFormField(
                    onTap: () async {
                      final dates = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year),
                        lastDate: DateTime(DateTime.now().year + 100),
                      );
                      startDate.text = date(dates!.toIso8601String());
                      controller.tempStartDate.value = dates.toIso8601String();
                    },
                    controller: startDate,
                    readOnly: true,
                    style: TextStyle(
                      color: primaryColor,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "End Date",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Card(
                  color: lightBackgroud,
                  elevation: 10,
                  shadowColor: secondaryColorAccent,
                  child: TextFormField(
                    onTap: () async {
                      final dates = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year),
                        lastDate: DateTime(DateTime.now().year + 100),
                      );
                      endDate.text = date(dates!.toIso8601String());
                      controller.tempEndDate.value = dates.toIso8601String();
                    },
                    controller: endDate,
                    readOnly: true,
                    style: TextStyle(
                      color: primaryColor,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "Type",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Card(
                  color: lightBackgroud,
                  elevation: 10,
                  shadowColor: secondaryColorAccent,
                  child: TextFormField(
                    onTap: () {
                      Get.bottomSheet(
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
                          color: Get.theme.scaffoldBackgroundColor,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text("Personal"),
                                onTap: () {
                                  type.text = "personal";
                                  Get.back();
                                },
                              ),
                              ListTile(
                                title: Text("Team"),
                                onTap: () {
                                  type.text = "team";
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    readOnly: true,
                    controller: type,
                    style: TextStyle(
                      color: primaryColor,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "Color",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Card(
                  color: lightBackgroud,
                  elevation: 10,
                  shadowColor: secondaryColorAccent,
                  child: TextFormField(
                    onTap: () {
                      Get.bottomSheet(
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
                          color: Get.theme.scaffoldBackgroundColor,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: listColor.length,
                            itemBuilder: (_, i) {
                              return ListTile(
                                onTap: () {
                                  color.text = listColor[i]['color'];
                                  Get.back();
                                },
                                title: Text("${listColor[i]['color']}"),
                                leading: CircleAvatar(
                                  backgroundColor: listColor[i]['colorData'],
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    readOnly: true,
                    controller: color,
                    style: TextStyle(
                      color: primaryColor,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "Description",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Card(
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
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
