import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:yo_task_managements/app/modules/todo/controllers/todo_controller.dart';

import '../../../config/helper.dart';
import '../../../config/theme.dart';
import '../../../data/models/todo.dart';

class UpdateTodoView extends GetView<TodoController> {
  final title = TextEditingController();
  final description = TextEditingController();
  final endDate = TextEditingController();
  final startDate = TextEditingController();
  @override
  Widget build(BuildContext context) {
    title.text = controller.todo.value.title!;
    description.text = controller.todo.value.description!;
    startDate.text = date(controller.todo.value.startDate!);
    endDate.text = date(controller.todo.value.endDate!);
    controller.tempEndDate.value = controller.todo.value.endDate!;
    controller.tempStartDate.value = controller.todo.value.startDate!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Todo'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              TodoModel todo = TodoModel(
                description: description.text,
                endDate: controller.tempEndDate.value,
                startDate: controller.tempStartDate.value,
                title: title.text,
              );
              controller.updateTodo(
                  todo, controller.task.value.taskId, controller.todo.value.id);
              controller.todo.update((val) {
                val!.description = description.text;
                val.title = title.text;
                val.startDate = controller.tempStartDate.value;
                val.endDate = controller.tempEndDate.value;
              });
              Get.back();
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
                      initialDate:
                          DateTime.parse(controller.task.value.startDate!),
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
                      initialDate:
                          DateTime.parse(controller.task.value.startDate!),
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
