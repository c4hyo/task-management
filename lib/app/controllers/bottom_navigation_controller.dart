import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:yo_task_managements/app/data/models/profile.dart';
import 'package:yo_task_managements/app/modules/home/controllers/home_controller.dart';
import 'package:yo_task_managements/app/routes/app_pages.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_date_view.dart';
import '../modules/task/bindings/task_binding.dart';
import '../modules/task/views/list_task_view.dart';

class BottomNavigationController extends GetxController {
  final initialPage = 2.obs;

  void changePage(int i, ProfileModel profileModel) async {
    initialPage.value = i;
    switch (i) {
      case 1:
        Get.offAll(
          () => ListTaskView(),
          arguments: {"profile": profileModel},
          binding: TaskBinding(),
          transition: Transition.fadeIn,
        );
        break;
      case 2:
        Get.offAllNamed(
          Routes.HOME,
        );
        break;
      case 3:
        Get.offAllNamed(
          Routes.NOTE,
          arguments: {"profile": profileModel},
        );
        break;
      case 0:
        Get.put(HomeController()).timeline.value = <Appointment>[];
        Get.offAll(
          () => HomeDateView(),
          binding: HomeBinding(),
          transition: Transition.fadeIn,
        );
        break;
      case 4:
        Get.offAllNamed(
          Routes.PROFILE,
          arguments: {"profile": profileModel},
        );
        break;
      default:
        Get.offAllNamed(Routes.HOME);
    }
  }
}
