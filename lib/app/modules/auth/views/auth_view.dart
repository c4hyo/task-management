import 'package:flutter/material.dart';

import 'package:fluttericon/font_awesome_icons.dart';

import 'package:get/get.dart';
import 'package:yo_task_managements/app/config/theme.dart';
import 'package:yo_task_managements/app/modules/auth/views/registration_view.dart';

import '../controllers/auth_controller.dart';

/// HALAMAN LOGIN
class AuthView extends GetView<AuthController> {
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.loading.isTrue
          ? Scaffold(
              //merupakan widget untuk loading login
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Scaffold(
              body: Padding(
                //memberi padding pada konten
                padding: EdgeInsets.fromLTRB(15, 20, 15,
                    20), // padding kiri 15, atas 20, kanan 15, dan bawah 20
                child: ListView(
                  // menapilkan data berbentuk list
                  children: [
                    SizedBox(
                      // memberi spasi antar widget sebesar 20% dari lebar layar
                      height: Get.size.width * 0.2,
                    ),
                    CircleAvatar(
                      // menampilakn lingkaran untuk avatar
                      radius: 40,
                      backgroundColor: primaryColor,
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: lightBackgroud,
                        child: Icon(
                          Icons.person_outline,
                          size: 50,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: darkText,
                        ),
                      ),
                    ),
                    Center(
                      child: Text("Sign in to continue"),
                    ),
                    SizedBox(
                      height: Get.size.width * 0.09,
                    ),
                    Card(
                      //card untuk form email
                      color: lightBackgroud,
                      elevation: 10,
                      shadowColor: secondaryColorAccent,
                      child: TextFormField(
                        // controller dari email, atau variabel email
                        controller: email,
                        // keyboard pada saat menekan form ini menjadi tipe email
                        keyboardType: TextInputType.emailAddress,
                        // style dari text yang ada di dalam form
                        style: TextStyle(
                          color: primaryColor,
                        ),
                        decoration: InputDecoration(
                          labelText: "EMAIL",
                          labelStyle: TextStyle(
                            color: darkText,
                          ),
                          border: InputBorder.none, // form ini tidak berborder
                          // icon pada sebelah kiri form
                          prefixIcon: Icon(
                            FontAwesome.mail_alt,
                          ),
                        ),
                      ),
                    ),
                    // memberi spasi antar widget sebesar 20% dari lebar layar
                    SizedBox(
                      height: Get.size.width * 0.02,
                    ),
                    Card(
                      color: lightBackgroud,
                      elevation: 10,
                      shadowColor: secondaryColorAccent,
                      // controller dari email, atau variabel email
                      child: TextFormField(
                        obscureText:
                            true, // supaya teks di dalam form tidak terlihat
                        controller: password, //  variabel dari form password
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
                          suffixIcon: InkWell(
                            // berfungsi untuk menampilakn teks di form password
                            child: Icon(
                              FontAwesome.eye,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        //supaya widget setelahnya terletak di pojok kanan dari row
                        Spacer(),
                        //digunakan untuk berpindah ke halaman forget password
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "Forgot Password",
                            style: TextStyle(
                              color: primaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: Get.size.width * 0.09,
                    ),
                    ElevatedButton(
                      //tombol yang digunakan untuk login
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        //proses login sistem
                        controller.login(
                          email: email.text,
                          password: password.text,
                        );
                      },
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.size.width * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have account? "),
                        //digunakan untuk berpindah ke halaman registrasi
                        InkWell(
                          onTap: () => Get.to(() => RegistrationView()),
                          child: Text(
                            "create new account",
                            style: TextStyle(
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
