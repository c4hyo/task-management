import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:yo_task_managements/app/controllers/app_controller.dart';
import 'package:yo_task_managements/app/controllers/bottom_navigation_controller.dart';
import 'package:yo_task_managements/app/modules/home/controllers/home_controller.dart';
import '../../../config/theme.dart';
import '../../../widget/card_user.dart';

class HomeDateView extends GetView<HomeController> {
  // memanggil app controller di HomeDateView
  final app = Get.find<AppController>();
  final btm = Get.find<BottomNavigationController>();
  @override
  Widget build(BuildContext context) {
    // memanggil fungsi getTimeline dari home controller
    controller.getTimeline(app.profileModel.uid!);

    return Scaffold(
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.flip,
        backgroundColor: primaryColor,
        height: Get.size.height * 0.075,
        color: lightBackgroud,
        activeColor: lightBackgroud,
        items: [
          TabItem(
            icon: Icon(
              Icons.calendar_today,
              color: lightBackgroud,
            ),
            title: "Events",
          ),
          TabItem(
            icon: Icon(
              Icons.task,
              color: lightBackgroud,
            ),
            title: "Task",
          ),
          TabItem(
            icon: Icon(
              Icons.home,
              color: lightBackgroud,
            ),
            title: "Home",
          ),
          TabItem(
            icon: Icon(
              Icons.note,
              color: lightBackgroud,
            ),
            title: "Note",
          ),
          TabItem(
            icon: profilePicture(app.profileModel.imageUrl),
            title: "Profile",
          ),
        ],
        initialActiveIndex: btm.initialPage.value,
        onTap: (int i) => btm.changePage(i, app.profileModel),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Task Schedule"),
      ),
      body: Obx(
        () => Container(
          width: Get.size.width,

          // digunakan untuk menampilkan kalender
          child: SfCalendar(
            // style header dari kalender
            headerStyle: CalendarHeaderStyle(
              textAlign: TextAlign.center,
              backgroundColor: lightBackgroud,
              textStyle: TextStyle(
                fontSize: 25,
                fontStyle: FontStyle.normal,
                letterSpacing: 5,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            // kalender yang tampil berbentuk kalender bulanan
            view: CalendarView.month,

            monthViewSettings: MonthViewSettings(
              agendaItemHeight: 70,
              // menampilkan agenda
              showAgenda: true,
              agendaStyle: AgendaStyle(
                appointmentTextStyle: TextStyle(
                  color: darkText,
                ),
              ),
            ),
            initialDisplayDate: DateTime.now(),
            initialSelectedDate: DateTime.now(),
            firstDayOfWeek: 6,
            // data kalendar
            dataSource: Timeline(
              _listTask(controller.timeline),
            ),
          ),
        ),
      ),
    );
  }

  List<Appointment> _listTask(List<Appointment> resource) {
    final data = <Appointment>[];
    resource.forEach((element) {
      data.add(element);
    });
    return data;
  }
}

class Timeline extends CalendarDataSource {
  Timeline(List<Appointment> source) {
    appointments = source;
  }
}
