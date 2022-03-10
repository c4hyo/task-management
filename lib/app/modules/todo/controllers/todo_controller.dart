import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:yo_task_managements/app/config/collection.dart';
import 'package:yo_task_managements/app/config/theme.dart';
import 'package:yo_task_managements/app/data/models/task.dart';
import 'package:yo_task_managements/app/data/models/todo.dart';
import 'package:yo_task_managements/app/modules/task/controllers/task_controller.dart';

class TodoController extends GetxController {
  // TaskModel? task;
  // TodoModel? todo;
  final task = TaskModel().obs;

  final todo = TodoModel().obs;
  final taskC = Get.find<TaskController>();
  var isNote = true.obs;
  var tempStartDate = "".obs;
  var tempEndDate = "".obs;

  addTodo(TodoModel todo) async {
    final task = await taskCollection.doc(todo.taskId).collection("todo").add({
      "task_id": todo.taskId,
      "title": todo.title,
      "description": todo.description,
      "end_date": todo.endDate,
      "start_date": todo.startDate,
      "status": todo.status,
      "editor": todo.editor,
      "created_at": DateTime.now().toIso8601String(),
    });
    int countTodo = await taskCollection
        .doc(todo.taskId)
        .collection("todo")
        .get()
        .then((value) => value.docs.length);
    if (countTodo == 0) {
      await taskCollection.doc(todo.taskId).update({
        "todo_count": 1,
      });
    } else {
      await taskCollection.doc(todo.taskId).update({
        "todo_count": countTodo,
      });
    }
    final todos = Appointment(
      id: task.id,
      isAllDay: true,
      color: primaryColor,
      subject: todo.title!.capitalize!,
      startTime: DateTime.parse(todo.startDate!),
      endTime: DateTime.parse(todo.endDate!),
    );
    taskC.listTodo.add(todos);
  }

  updateTodo(TodoModel todo, String? taskId, String? todoId) async {
    await taskCollection.doc(taskId).collection("todo").doc(todoId).update({
      "title": todo.title,
      "description": todo.description,
      "end_date": todo.endDate,
      "start_date": todo.startDate,
    });
    final todos = Appointment(
      id: todoId,
      isAllDay: true,
      color: primaryColor,
      subject: todo.title!.capitalize!,
      startTime: DateTime.parse(todo.startDate!),
      endTime: DateTime.parse(todo.endDate!),
    );
    taskC.listTodo[
        taskC.listTodo.indexWhere((element) => element.id == todoId)] = todos;
  }

  bool cekEditor(String uid, TodoModel todo) {
    return todo.editor!.contains(uid);
  }

  Stream<List<dynamic>> getEditor(String? taskId, String? todoId) {
    return taskCollection
        .doc(taskId)
        .collection("todo")
        .doc(todoId)
        .snapshots()
        .map((event) => event['editor']);
  }

  finishTodo(TodoModel tm) async {
    await taskCollection.doc(tm.taskId).collection("todo").doc(tm.id).update({
      "status": "finish",
    }).then((value) async {
      int countTodo = await taskCollection
          .doc(tm.taskId)
          .collection("todo")
          .where("status", isEqualTo: "finish")
          .get()
          .then((value) => value.docs.length);
      await taskCollection.doc(tm.taskId).update({"todo_finish": countTodo});
    });
  }

  unfinishTodo(TodoModel todo) async {
    await taskCollection
        .doc(todo.taskId)
        .collection("todo")
        .doc(todo.id)
        .update({
      "status": "new",
    }).then((value) async {
      int countTodo = await taskCollection
          .doc(todo.taskId)
          .collection("todo")
          .where("status", isEqualTo: "finish")
          .get()
          .then((value) => value.docs.length);
      await taskCollection.doc(todo.taskId).update({"todo_finish": countTodo});
    });
  }

  deleteTodo(String? taskId, TodoModel? todo) async {
    await taskCollection
        .doc(taskId)
        .collection("todo")
        .doc(todo!.id)
        .collection("note")
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          taskCollection
              .doc(taskId)
              .collection("todo")
              .doc(todo.id)
              .collection("note")
              .doc(element.id)
              .delete();
        });
      }
    });
    await taskCollection.doc(taskId).collection("todo").doc(todo.id).delete();
    int countTodoFinish = await taskCollection
        .doc(taskId)
        .collection("todo")
        .where("status", isEqualTo: "finish")
        .get()
        .then((value) => value.docs.length);
    int countTodo = await taskCollection
        .doc(taskId)
        .collection("todo")
        .get()
        .then((value) => value.docs.length);
    await taskCollection.doc(taskId).update({"todo_finish": countTodoFinish});
    await taskCollection.doc(taskId).update({"todo_count": countTodo});
    taskC.listTodo.removeWhere((element) => element.id == todo.id);
  }

  @override
  void onInit() {
    super.onInit();
    // task.value = task(Get.arguments['task']);
    task.value = task(Get.arguments['task']);
    todo.value = todo(Get.arguments['todo'] ?? TodoModel());
    print("task " + Get.arguments['task'].toString());
  }

  @override
  void onClose() {
    task.value = task(TaskModel());
    todo.value = todo(TodoModel());
  }
}
