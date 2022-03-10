import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:yo_task_managements/app/controllers/app_controller.dart';
import 'package:yo_task_managements/app/modules/todo/controllers/todo_controller.dart';
import 'package:yo_task_managements/app/modules/todo/views/update_todo_view.dart';

import '../../../config/theme.dart';
import '../bindings/todo_binding.dart';

class SettingTodoView extends GetView<TodoController> {
  final myId = Get.find<AppController>().profileModel.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting Todo'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text("Update data todo"),
              onTap: () {
                Get.to(
                  () => UpdateTodoView(),
                  arguments: {
                    "task": controller.task.value,
                    "todo": controller.todo.value
                  },
                  binding: TodoBinding(),
                );
              },
            ),
          ),
          Visibility(
            visible: controller.todo.value.status == "finish",
            child: Card(
              child: ListTile(
                title: Text("Cancel finish"),
                onTap: () {
                  controller.unfinishTodo(controller.todo.value);
                  Get.back();
                },
              ),
            ),
          ),
          Visibility(
            visible: controller.todo.value.status != "finish",
            child: Card(
              child: ListTile(
                onTap: () {
                  controller.finishTodo(controller.todo.value);
                  Get.back();
                },
                title: Text("Finish todo"),
              ),
            ),
          ),
          Visibility(
            visible: controller.task.value.ownerId == myId &&
                controller.todo.value.status != "finish",
            child: Card(
              child: ListTile(
                onTap: () {
                  // Get.back();
                  Get.defaultDialog(
                    confirm: ElevatedButton(
                      style: bs,
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        "No",
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                    cancel: ElevatedButton(
                      onPressed: () async {
                        await controller.deleteTodo(
                          controller.task.value.taskId,
                          controller.todo.value,
                        );
                        Get.back();
                        Get.back();
                      },
                      child: Text("Yes"),
                    ),
                    title: "Delete Todo",
                    middleText: "Are you sure to delete todo",
                  );
                },
                title: Text("Delete todo"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
