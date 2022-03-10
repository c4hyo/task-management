import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:yo_task_managements/app/config/collection.dart';
import 'package:yo_task_managements/app/config/helper.dart';
import 'package:yo_task_managements/app/config/theme.dart';
import 'package:yo_task_managements/app/modules/home/controllers/home_controller.dart';
import 'package:yo_task_managements/app/modules/task/bindings/task_binding.dart';
import 'package:yo_task_managements/app/modules/task/controllers/task_controller.dart';
import 'package:yo_task_managements/app/modules/task/views/update_task_view.dart';

class SettingTaskView extends GetView<TaskController> {
  final home = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Setting Task',
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: Text("Update data task"),
              onTap: () {
                Get.to(
                  () => UpdateTaskView(),
                  arguments: {"task": controller.task.value},
                  binding: TaskBinding(),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Generate new code"),
              onTap: () {
                var random = randomString();
                taskCollection.doc(controller.task.value.taskId).update({
                  "code": random,
                });
                controller.task.update((val) {
                  val!.code = random;
                });
                Get.back();
              },
            ),
          ),
          Card(
            child: ListTile(
              onTap: () {
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
                      controller.deleteTask(controller.task.value.taskId!);
                      home.timeline.removeWhere(
                        (element) => element.id == controller.task.value.taskId,
                      );
                      Get.back();
                      Get.back();
                      Get.back();
                    },
                    child: Text("Yes"),
                  ),
                  title: "Delete Task",
                  middleText: "Are you sure to delete task",
                );
              },
              title: Text("Delete task"),
            ),
          ),
        ],
      ),
    );
  }
}
