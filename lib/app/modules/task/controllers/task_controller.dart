import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:yo_task_managements/app/config/collection.dart';
import 'package:yo_task_managements/app/config/theme.dart';

import 'package:yo_task_managements/app/data/models/profile.dart';
import 'package:yo_task_managements/app/data/models/task.dart';
import 'package:yo_task_managements/app/data/models/todo.dart';
import 'package:yo_task_managements/app/modules/home/controllers/home_controller.dart';

class TaskController extends GetxController {
  final listTodo = <Appointment>[].obs;
  final homeC = Get.find<HomeController>();

  ProfileModel? profileTask;
  // TaskModel? task;
  final task = TaskModel().obs;
  var showCode = false.obs;
  var isTask = true.obs;
  var todoData = "all".obs;
  var tempStartDate = "".obs;
  var tempEndDate = "".obs;

  addtask(TaskModel task) async {
    final getId = await taskCollection.add({
      "title": task.title,
      "start_date": task.startDate,
      "end_date": task.endDate,
      "type": task.type,
      "code": task.code,
      "color": task.color,
      "owner_id": task.ownerId,
      "member": task.member,
      "created_at": DateTime.now().toIso8601String(),
      "description": task.description,
      "category": task.category,
      "todo_count": 0,
      "todo_finish": 0,
    });
    final appo = Appointment(
      id: getId.id,
      subject: task.title!.capitalize!,
      notes: task.description!,
      color: cardColor(task.color!),
      startTime: DateTime.parse(task.startDate!),
      endTime: DateTime.parse(task.endDate!),
      isAllDay: true,
    );
    homeC.timeline.add(appo);
  }

  updateTask(TaskModel task, String taskId) async {
    await taskCollection.doc(taskId).update({
      "title": task.title,
      "start_date": task.startDate,
      "end_date": task.endDate,
      "type": task.type,
      "color": task.color,
      "description": task.description,
      "category": task.category,
    });
  }

  deleteTask(String taskId) async {
    await taskCollection.doc(taskId).collection("todo").get().then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          taskCollection
              .doc(taskId)
              .collection("todo")
              .doc(element.id)
              .delete();
        });
      }
    });
    await taskCollection.doc(taskId).delete();
  }

  Stream<List<dynamic>> getMember(String? taskId) {
    return taskCollection.doc(taskId).snapshots().map((event) {
      return event['member'];
    });
  }

  RxList<Appointment> getlistTodo(String taskId) {
    taskCollection.doc(taskId).collection("todo").get().then((value) {
      value.docs.forEach((element) {
        listTodo.add(
          Appointment(
            id: element.id,
            color: primaryColor,
            isAllDay: false,
            subject: element['title'].toString().capitalize!,
            startTime: DateTime.parse(element['start_date']),
            endTime: DateTime.parse(element['end_date']),
            notes: element['description'],
          ),
        );
      });
    });
    return listTodo;
  }

  int getNotedCount(TaskModel task, TodoModel todo) {
    int counts = 0;
    taskCollection
        .doc(task.taskId)
        .collection("todo")
        .doc(todo.id)
        .collection("note")
        .where("is_finished", isEqualTo: false)
        .get()
        .then((value) => counts = value.docs.length);
    return counts;
  }

  Stream<int> getNoteCountStream(TaskModel task, TodoModel todo) {
    return taskCollection
        .doc(task.taskId)
        .collection("todo")
        .doc(todo.id)
        .collection("note")
        .where("is_finished", isEqualTo: false)
        .snapshots()
        .map((event) => event.docs.length);
  }

  Stream<QuerySnapshot> getTodo(String? condition, {String? taskId}) {
    if (condition == "all") {
      return taskCollection
          .doc(taskId)
          .collection("todo")
          .orderBy("start_date", descending: true)
          .snapshots();
    } else if (condition == "finish") {
      return taskCollection
          .doc(taskId)
          .collection("todo")
          .where("status", isEqualTo: "finish")
          .orderBy("start_date", descending: true)
          .snapshots();
    } else {
      return taskCollection
          .doc(taskId)
          .collection("todo")
          .where("status", isEqualTo: "new")
          .orderBy("start_date", descending: true)
          .snapshots();
    }
  }

  @override
  void onInit() {
    profileTask = Get.arguments['profile'];
    task.value = task(Get.arguments['task'] ?? TaskModel());
    super.onInit();
  }

  @override
  void onClose() {
    profileTask = ProfileModel();
    task.value = TaskModel();
    listTodo.value = <Appointment>[];
  }
}
