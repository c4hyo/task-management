import 'package:flutter/material.dart';
import 'package:fluttericon/fontelico_icons.dart';
import 'package:get/get.dart';
import 'package:yo_task_managements/app/config/theme.dart';
import 'package:yo_task_managements/app/data/models/profile.dart';
import 'package:yo_task_managements/app/data/models/task.dart';
import 'package:yo_task_managements/app/data/models/todo.dart';

import 'package:yo_task_managements/app/modules/todo/views/editor_view.dart';
import 'package:yo_task_managements/app/modules/todo/views/notes_view.dart';
import '../../../config/helper.dart';
import '../../../controllers/app_controller.dart';

import '../../../widget/icon_badge.dart';
import '../../todo/bindings/todo_binding.dart';
import '../../todo/views/setting_todo_view.dart';
import '../controllers/task_controller.dart';

Widget cardTodoView(TodoModel todo, ProfileModel profileModel, TaskModel task) {
  final myId = Get.find<AppController>().profileModel.uid;

  final taskC = Get.find<TaskController>();
  return Card(
    child: Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: todo.status! == "finish" ? greenUi : orangeUi,
              child: Icon(
                todo.status! == "finish" ? Icons.check : Fontelico.spin5,
                color: darkText,
              ),
            ),
            title: Text(
              todo.title!.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            trailing: Visibility(
              visible: todo.status! != "finish",
              child: Chip(
                backgroundColor: deadlineColor(
                  dateDiff(DateTime.now().toIso8601String(), todo.endDate),
                ),
                label: Text(
                  deadlineText(
                    dateDiff(DateTime.now().toIso8601String(), todo.endDate),
                  ),
                ),
              ),
            ),
          ),
          Text(
            "Start : ${date(
              todo.startDate,
            )}",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          Text(
            "Deadline : ${date(
              todo.endDate,
            )}",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Description : ",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            todo.description!,
          ),
          SizedBox(
            height: 15,
          ),
          Divider(),
          Row(
            mainAxisAlignment: todo.editor!.contains([myId])
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceAround,
            children: [
              Visibility(
                visible: todo.editor!.contains(profileModel.uid),
                child: IconButton(
                  onPressed: () {
                    if (todo.editor!.contains(profileModel.uid)) {
                      Get.to(
                        () => SettingTodoView(),
                        arguments: {
                          "task": task,
                          "todo": todo,
                        },
                        binding: TodoBinding(),
                      );
                    }
                  },
                  icon: Icon(
                    Icons.settings,
                    size: 20,
                  ),
                ),
              ),
              StreamBuilder<int>(
                stream: taskC.getNoteCountStream(task, todo),
                builder: (_, sn) {
                  if (!sn.hasData) {
                    return BadgeIcons(
                      count: taskC.getNotedCount(task, todo),
                      icon: Icons.note_outlined,
                      onTap: () {
                        Get.to(
                          () => NotesView(),
                          arguments: {
                            "task": task,
                            "todo": todo,
                          },
                          binding: TodoBinding(),
                          transition: Transition.rightToLeftWithFade,
                        );
                      },
                      isZero: taskC.getNotedCount(task, todo).isEqual(0),
                    );
                  }
                  return BadgeIcons(
                    count: sn.data!,
                    icon: Icons.note_outlined,
                    onTap: () {
                      Get.to(
                        () => NotesView(),
                        arguments: {
                          "task": task,
                          "todo": todo,
                        },
                        binding: TodoBinding(),
                        transition: Transition.rightToLeftWithFade,
                      );
                    },
                    isZero: sn.data!.isEqual(0),
                  );
                },
              ),
              Visibility(
                visible: task.type == "team",
                child: BadgeIcons(
                  count: todo.editor!.length,
                  icon: Icons.people_rounded,
                  onTap: () {
                    Get.to(
                      () => EditorView(),
                      arguments: {
                        "task": task,
                        "todo": todo,
                      },
                      binding: TodoBinding(),
                      transition: Transition.rightToLeftWithFade,
                    );
                  },
                  isZero: todo.editor!.isEmpty,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
