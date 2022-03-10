import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:yo_task_managements/app/config/helper.dart';
import 'package:yo_task_managements/app/config/theme.dart';
import 'package:yo_task_managements/app/data/models/todo.dart';
import '../controllers/todo_controller.dart';

class TodoView extends GetView<TodoController> {
  // final taskC = Get.find<TaskController>();
  final title = TextEditingController();
  final description = TextEditingController();
  final endDate = TextEditingController();
  final startDate = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add ToDo'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              TodoModel todo = TodoModel(
                description: description.text,
                endDate: controller.tempEndDate.value,
                startDate: controller.tempStartDate.value,
                status: "new",
                taskId: controller.task.value.taskId,
                title: title.text,
                editor: [controller.task.value.ownerId!],
              );
              controller.addTodo(todo);

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
                "ToDo",
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
                      firstDate:
                          DateTime.parse(controller.task.value.startDate!),
                      lastDate: DateTime.parse(controller.task.value.endDate!),
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
                      firstDate:
                          DateTime.parse(controller.task.value.startDate!),
                      lastDate: DateTime.parse(controller.task.value.endDate!),
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
          ],
        ),
      ),
    );
  }
}
