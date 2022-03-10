import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';

import 'package:get/get.dart';
import 'package:yo_task_managements/app/data/models/profile.dart';
import 'package:yo_task_managements/app/modules/auth/controllers/auth_controller.dart';

import '../../../config/theme.dart';

class RegistrationView extends GetView<AuthController> {
  final name = TextEditingController();
  final email = TextEditingController();
  final city = TextEditingController();
  final confirm = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.loading.isTrue
          ? Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                title: Text(''),
                centerTitle: true,
              ),
              body: Padding(
                padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                child: ListView(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: primaryColor,
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: lightBackgroud,
                        child: Icon(
                          Icons.person_add_alt_1_outlined,
                          size: 50,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: darkText,
                        ),
                      ),
                    ),
                    Center(
                      child: Text("Create a new Account"),
                    ),
                    SizedBox(
                      height: Get.size.width * 0.09,
                    ),
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
                    SizedBox(
                      height: Get.size.width * 0.02,
                    ),
                    Card(
                      color: lightBackgroud,
                      elevation: 10,
                      shadowColor: secondaryColorAccent,
                      child: TextFormField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: primaryColor,
                        ),
                        decoration: InputDecoration(
                          labelText: "EMAIL",
                          labelStyle: TextStyle(
                            color: darkText,
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            FontAwesome.mail_alt,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.size.width * 0.02,
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
                    SizedBox(
                      height: Get.size.width * 0.02,
                    ),
                    Card(
                      color: lightBackgroud,
                      elevation: 10,
                      shadowColor: secondaryColorAccent,
                      child: TextFormField(
                        controller: password,
                        obscureText: true,
                        style: TextStyle(
                          color: primaryColor,
                        ),
                        decoration: InputDecoration(
                          labelText: "PASSWORD",
                          labelStyle: TextStyle(
                            color: darkText,
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            FontAwesome.lock,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.size.width * 0.02,
                    ),
                    Card(
                      color: lightBackgroud,
                      elevation: 10,
                      shadowColor: secondaryColorAccent,
                      child: TextFormField(
                        controller: confirm,
                        obscureText: true,
                        style: TextStyle(
                          color: primaryColor,
                        ),
                        decoration: InputDecoration(
                          labelText: "CONFIRM PASSWORD",
                          labelStyle: TextStyle(
                            color: darkText,
                          ),
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            FontAwesome.lock,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.size.width * 0.09,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        if (confirm.text == password.text) {
                          ProfileModel profileModel = ProfileModel(
                            city: city.text,
                            email: email.text,
                            imageUrl: "",
                            lang: "en",
                            name: name.text,
                            theme: "",
                          );
                          controller.registration(profileModel, password.text);
                        } else {
                          print("proses dibatalkan");
                        }
                      },
                      child: Text(
                        "CREATE ACCOUNT",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
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
