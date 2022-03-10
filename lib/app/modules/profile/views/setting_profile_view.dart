import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:yo_task_managements/app/config/collection.dart';
import 'package:yo_task_managements/app/config/theme.dart';
import 'package:yo_task_managements/app/controllers/app_controller.dart';
import 'package:yo_task_managements/app/modules/home/controllers/home_controller.dart';
import 'package:yo_task_managements/app/modules/profile/bindings/profile_binding.dart';
import 'package:yo_task_managements/app/modules/profile/controllers/profile_controller.dart';
import 'package:yo_task_managements/app/modules/profile/views/edit_profile_view.dart';
import 'package:yo_task_managements/app/modules/profile/views/request_friend_view.dart';
import 'package:yo_task_managements/app/modules/profile/views/upload_photo_view.dart';

class SettingProfileView extends GetView<ProfileController> {
  final home = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: ListView(
          children: [
            ListTile(
              title: Text("Change photo profile"),
              leading: Icon(FontAwesome.picture),
              onTap: () {
                controller.resetImage();
                Get.to(
                  () => UploadPhotoView(),
                  arguments: {"profile": controller.profile.value},
                  binding: ProfileBinding(),
                );
              },
            ),
            ListTile(
              title: Text("Edit profile"),
              leading: Icon(FontAwesome.pencil),
              onTap: () {
                Get.to(
                  () => EditProfileView(),
                  arguments: {"profile": controller.profile.value},
                  binding: ProfileBinding(),
                );
              },
            ),
            ListTile(
              title: Text("Request friend"),
              leading: Icon(Icons.person_add_alt_1),
              onTap: () {
                Get.to(
                  () => RequestFriendView(),
                  arguments: {"profile": controller.profile.value},
                  binding: ProfileBinding(),
                );
              },
            ),
            ListTile(
              title: Text("Theme"),
              leading: Icon(FontAwesome.brush),
              onTap: () {
                Get.changeTheme(Get.isDarkMode ? light : dark);
              },
            ),
            ListTile(
              title: Text("Language"),
              leading: Icon(FontAwesome.language),
            ),
            ListTile(
              title: Text("Sign out"),
              leading: Icon(FontAwesome.logout),
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
                    onPressed: () {
                      auth.signOut();
                      Get.find<AppController>().resetProfile();
                      home.timeline.value = <Appointment>[];
                      Get.back();
                      Get.back();
                      Get.back();
                    },
                    child: Text("Yes"),
                  ),
                  title: "Sign Out",
                  middleText: "Are you sure to sign out",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
