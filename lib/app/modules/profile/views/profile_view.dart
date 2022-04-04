import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:yo_task_managements/app/config/theme.dart';
import 'package:yo_task_managements/app/controllers/app_controller.dart';
import 'package:yo_task_managements/app/modules/profile/bindings/profile_binding.dart';
import 'package:yo_task_managements/app/modules/profile/views/setting_profile_view.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final loginProfile = Get.find<AppController>().profileModel;
  @override
  Widget build(BuildContext context) {
    controller.notesCount
        .bindStream(controller.getCountNotes(controller.profile.value.uid!));
    controller.taskTeamCount
        .bindStream(controller.getTaskTeam(controller.profile.value.uid));
    controller.taskPersonalCount
        .bindStream(controller.getTaskPersonal(controller.profile.value.uid));
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
          child: ListView(
            children: [
              Container(
                height: Get.size.height * 0.5,
                width: Get.size.width,
                child: controller.profile.value.imageUrl!.isEmpty
                    ? Center(
                        child: Icon(
                          Icons.person_outline,
                          size: Get.size.height * 0.2,
                        ),
                      )
                    : Image.network(
                        controller.profile.value.imageUrl!,
                        fit: BoxFit.fitWidth,
                      ),
              ),

              SizedBox(
                height: 20,
              ),
              Text(
                controller.profile.value.name!.capitalize!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Text(
                controller.profile.value.city!.capitalize!,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: Get.size.width * 0.275,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Task Team"),
                        Text(
                          "${controller.taskTeamCount}",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    width: Get.size.width * 0.275,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Task Personal"),
                        Text(
                          "${controller.taskPersonalCount}",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    width: Get.size.width * 0.275,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Notes"),
                        Text(
                          "${controller.notesCount.value}",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              // IconButton(
              //   onPressed: () {
              //     auth.signOut();
              //     Get.find<AppController>().resetProfile();
              //     Get.back();
              //   },
              //   icon: Icon(
              //     FontAwesome.logout,
              //   ),
              // ),
              Container(
                child: (controller.profile.value.uid! != loginProfile.uid)
                    ? Visibility(
                        visible: false,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            "Add Friend",
                            style: TextStyle(),
                          ),
                        ),
                      )
                    : ElevatedButton(
                        style: bs,
                        onPressed: () {
                          Get.to(
                            () => SettingProfileView(),
                            arguments: {"profile": controller.profile.value},
                            binding: ProfileBinding(),
                          );
                        },
                        child: Text(
                          "Settings",
                          style: TextStyle(
                            color: primaryColor,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
