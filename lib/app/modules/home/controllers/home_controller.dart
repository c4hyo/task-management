import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:yo_task_managements/app/config/collection.dart';
import 'package:yo_task_managements/app/controllers/app_controller.dart';

import '../../../config/theme.dart';

class HomeController extends GetxController {
  final timeline = <Appointment>[].obs;
  final myId = Get.find<AppController>().profileModel.uid;
  final notesCount = 0.obs;
  final taskCount = 0.obs;

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

    return timeline;
  }

  Stream<int> getCountNotes(String uid) {
    return notesCollection
        .where("ownerId", isEqualTo: uid)
        .snapshots()
        .map((event) => event.docs.length);
  }

  Stream<int> getTaskCount(String uid) {
    return taskCollection
        .where("member", arrayContains: myId)
        .snapshots()
        .map((event) => event.docs.length);
  }

  // @override
  // void onInit() {
  //   super.onInit();
  // }
}
