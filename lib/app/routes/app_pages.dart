import 'package:get/get.dart';

import 'package:yo_task_managements/app/modules/auth/bindings/auth_binding.dart';
import 'package:yo_task_managements/app/modules/auth/views/auth_view.dart';
import 'package:yo_task_managements/app/modules/home/bindings/home_binding.dart';
import 'package:yo_task_managements/app/modules/home/views/home_view.dart';
import 'package:yo_task_managements/app/modules/note/bindings/note_binding.dart';
import 'package:yo_task_managements/app/modules/note/views/note_view.dart';
import 'package:yo_task_managements/app/modules/profile/bindings/profile_binding.dart';
import 'package:yo_task_managements/app/modules/profile/views/profile_view.dart';
import 'package:yo_task_managements/app/modules/search/bindings/search_binding.dart';
import 'package:yo_task_managements/app/modules/search/views/search_view.dart';
import 'package:yo_task_managements/app/modules/task/bindings/task_binding.dart';
import 'package:yo_task_managements/app/modules/task/views/task_view.dart';
import 'package:yo_task_managements/app/modules/task/views/update_task_view.dart';
import 'package:yo_task_managements/app/modules/todo/bindings/todo_binding.dart';
import 'package:yo_task_managements/app/modules/todo/views/detail_todo_view.dart';
import 'package:yo_task_managements/app/modules/todo/views/todo_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.TASK,
      page: () => TaskView(),
      binding: TaskBinding(),
    ),
    GetPage(
      name: _Paths.TASK_UPDATE,
      page: () => UpdateTaskView(),
      binding: TaskBinding(),
    ),
    GetPage(
      name: _Paths.TODO,
      page: () => TodoView(),
      binding: TodoBinding(),
    ),
    GetPage(
      name: _Paths.TODO_DETAIL,
      page: () => DetailTodoView(),
      binding: TodoBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.NOTE,
      page: () => NoteView(),
      binding: NoteBinding(),
      transition: Transition.fadeIn,
    ),
  ];
}
