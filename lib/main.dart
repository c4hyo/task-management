import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:yo_task_managements/app/config/lang.dart';
import 'package:yo_task_managements/app/config/theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:yo_task_managements/app/controllers/app_controller.dart';
import 'package:yo_task_managements/app/modules/auth/views/auth_view.dart';
import 'package:yo_task_managements/app/modules/home/views/home_view.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBindings(),
      debugShowCheckedModeBanner: false,
      translations: Bahasa(),
      locale: Locale("en"),
      title: "Application",
      getPages: AppPages.routes,
      theme: light,
      home: WrapAuth(),
    );
  }
}

// Wrap auth
// digunakan untuk mengecek apakah user sudah login atau belum
class WrapAuth extends StatelessWidget {
  const WrapAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<AppController>(
      init: AppController(), // inisialisasi appcontroller
      builder: (_) {
        if (Get.find<AppController>().user?.uid != null) {
          // mengecek apakah uid user sudah ada atau belum / user sudah login
          if (Get.find<AppController>().profileModel.uid == null) {
            // mengecek apak uid di profilemodel sudah ada atau belum
            Get.find<AppController>().getProfileUser(
              Get.find<AppController>().user!.uid,
            ); // mendapatkan data profile dari firestore yang akan digunakan dihalaman selanjutnya
          } else {
            return HomeView(); //menuju homeview
          }
          return Scaffold(
            body: Center(
              child:
                  CircularProgressIndicator(), // loading untuk data profil dari firestor
            ),
          );
        } else {
          return AuthView(); // jika belum login atau sudah keluar, maka akan menuju halaman login AuthView == Login View
        }
      },
    );
  }
}
