import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:yo_task_managements/app/config/collection.dart';
import 'package:yo_task_managements/app/controllers/app_controller.dart';
import 'package:yo_task_managements/app/data/models/profile.dart';

class AuthController extends GetxController {
  var loading =
      false.obs; //digunakan untuk memberi tanda proses login atau registrasi

  /// Berfungsi untuk proses login sistem
  ///
  /// parameter password[String] dan email [String]

  login({String? password, String? email}) async {
    loading.value = true;
    try {
      await auth
          .signInWithEmailAndPassword(
              email: email!, password: password!) // fungsi login dari firebase
          .then((value) async {
        //berfungsi untuk mengisi data profil yang akan disimpan di appController
        return Get.find<AppController>().profileModel =
            await Get.find<AppController>().profileUser(value.user!.uid);
      });

      loading.value = false;
    } catch (e) {
      print("gasgal");
      loading.value = false;
    }
  }

  /// Berfungsi untuk
  /// - menambahkan user baru ke sistem
  /// - mengisi data profil yang akan disimpan di appController
  ///
  /// parameter password[String] dan profileModel [ProfileModel]

  registration(ProfileModel profileModel, String? password) async {
    loading.value = true;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: profileModel.email!,
          password: password!); //fungsi registrasi user dari firebase
      ProfileModel pm = ProfileModel(
        city: profileModel.city,
        email: profileModel.email,
        imageUrl: "",
        lang: "en",
        name: profileModel.name,
        theme: "light",
        uid: userCredential.user!.uid,
      );
      //menambahkan data profile di firestore
      if (await Get.find<AppController>().createProfile(pm)) {
        // menambahkan data profile di app controller
        Get.find<AppController>().profileModel = pm;
        loading.value = false;
        Get.back(); // menuju halaman login
      }
      loading.value = false;
    } catch (e) {
      loading.value = false;
    }
  }
}
