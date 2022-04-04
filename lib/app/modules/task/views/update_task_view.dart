import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:yo_task_managements/app/modules/home/controllers/home_controller.dart';
import 'package:yo_task_managements/app/modules/task/controllers/task_controller.dart';

import '../../../config/helper.dart';
import '../../../config/theme.dart';
import '../../../data/models/task.dart';

class UpdateTaskView extends GetView<TaskController> {
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
    title.text = controller.task.value.title!;
    category.text = controller.task.value.category!;
    endDate.text = date(controller.task.value.endDate!);
    startDate.text = date(controller.task.value.startDate!);
    type.text = controller.task.value.type!;
    color.text = controller.task.value.color!;
    description.text = controller.task.value.description!;
    controller.tempEndDate.value = controller.task.value.endDate!;
    controller.tempStartDate.value = controller.task.value.startDate!;
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              TaskModel tm = TaskModel(
                category: category.text,
                color: color.text,
                description: description.text,
                endDate: controller.tempEndDate.value,
                startDate: controller.tempStartDate.value,
                title: title.text,
                type: type.text,
              );
              controller.task.update((val) {
                val!.color = color.text;
                val.category = category.text;
                val.title = title.text;
                val.description = description.text;
                val.endDate = controller.tempEndDate.value;
                val.startDate = controller.tempStartDate.value;
                val.type = type.text;
              });

              controller.updateTask(tm, controller.task.value.taskId!);

              Get.back();
              Get.back();
            },
            icon: Icon(Icons.check_outlined),
          ),
        ],
      ),
      body: ListView(
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
          // ListTile(
          //   title: Text(
          //     "Category",
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          //   subtitle: Card(
          //     color: lightBackgroud,
          //     elevation: 10,
          //     shadowColor: secondaryColorAccent,
          //     child: TextFormField(
          //       onTap: () {
          //         Get.bottomSheet(
          //           Container(
          //             padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
          //             color: Get.theme.scaffoldBackgroundColor,
          //             child: FutureBuilder<QuerySnapshot>(
          //               future: categoryCollection.orderBy("category").get(),
          //               builder: (_, snapshot) {
          //                 if (!snapshot.hasData) {
          //                   return Center(
          //                     child: CircularProgressIndicator(),
          //                   );
          //                 }
          //                 return ListView.builder(
          //                   shrinkWrap: true,
          //                   itemCount: snapshot.data!.docs.length,
          //                   itemBuilder: (_, i) {
          //                     DocumentSnapshot doc = snapshot.data!.docs[i];
          //                     CategoryModel cm = CategoryModel.doc(doc);
          //                     return ListTile(
          //                       onTap: () {
          //                         category.text = cm.category!;
          //                         Get.back();
          //                       },
          //                       title: Text("${cm.category}".capitalize!),
          //                     );
          //                   },
          //                 );
          //               },
          //             ),
          //           ),
          //         );
          //       },
          //       readOnly: true,
          //       controller: category,
          //       style: TextStyle(
          //         color: primaryColor,
          //       ),
          //       decoration: InputDecoration(
          //         contentPadding: EdgeInsets.only(left: 10, right: 10),
          //         border: InputBorder.none,
          //       ),
          //     ),
          //   ),
          // ),
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
                  // startDate.text = dates!.toIso8601String();
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
                    initialDate: DateTime.parse(controller.task.value.endDate!),
                    firstDate: DateTime(DateTime.now().year),
                    lastDate: DateTime(DateTime.now().year + 100),
                  );
                  // endDate.text = dates!.toIso8601String();
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
    );
  }
}
