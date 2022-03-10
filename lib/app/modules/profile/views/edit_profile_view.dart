import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';

import 'package:get/get.dart';
import 'package:yo_task_managements/app/controllers/app_controller.dart';
import 'package:yo_task_managements/app/data/models/profile.dart';
import 'package:yo_task_managements/app/modules/profile/controllers/profile_controller.dart';

import '../../../config/theme.dart';

class EditProfileView extends GetView<ProfileController> {
  final name = TextEditingController();
  final city = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final myId = Get.find<AppController>().profileModel.uid;
    name.text = controller.profile.value.name!;
    city.text = controller.profile.value.city!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ProfileModel pm = ProfileModel(
                name: name.text,
                city: city.text,
              );

              controller.updateProfile(pm, myId);
              controller.profile.update((val) {
                val!.name = name.text;
                val.city = city.text;
              });

              Get.back();
            },
            icon: Icon(Icons.check_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: ListView(
          children: [
            Card(
              color: lightBackgroud,
              elevation: 10,
              shadowColor: secondaryColorAccent,
              child: TextFormField(
                controller: name,
                style: TextStyle(
                  color: primaryColor,
                ),
                decoration: InputDecoration(
                  labelText: "NAME",
                  labelStyle: TextStyle(
                    color: darkText,
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    FontAwesome.user,
                  ),
                ),
              ),
            ),
            Card(
              color: lightBackgroud,
              elevation: 10,
              shadowColor: secondaryColorAccent,
              child: TextFormField(
                controller: city,
                style: TextStyle(
                  color: primaryColor,
                ),
                decoration: InputDecoration(
                  labelText: "CITY",
                  labelStyle: TextStyle(
                    color: darkText,
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    FontAwesome.map_o,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
