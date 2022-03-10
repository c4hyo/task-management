import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:yo_task_managements/app/config/collection.dart';
import 'package:yo_task_managements/app/controllers/app_controller.dart';

import '../../../config/theme.dart';

class HomeController extends GetxController {
  final timeline = <Appointment>[].obs;
  final myId = Get.find<AppController>().profileModel.uid;

  RxList<Appointment> getTimeline(String uid) {
    taskCollection.where("member", arrayContains: uid).get().then((value) {
      value.docs.forEach((element) {
        timeline.add(
          Appointment(
            id: element.id,
            color: cardColor(element['color']),
            isAllDay: false,
            subject: element['title'].toString().capitalize!,
            startTime: DateTime.parse(element['start_date']),
            endTime: DateTime.parse(element['end_date']),
            notes: element['description'],
          ),
        );
      });
    });
    print("new data");
    return timeline;
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }
}
