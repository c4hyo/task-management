import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:yo_task_managements/app/config/collection.dart';
import 'package:yo_task_managements/app/data/models/profile.dart';
import 'package:yo_task_managements/app/modules/home/controllers/home_controller.dart';

import '../config/helper.dart';
import '../modules/auth/controllers/auth_controller.dart';

class AppController extends GetxController {
  final Rxn<User> _user = Rxn<User>();
  User? get user => _user.value;

  final _profile = ProfileModel().obs;
  ProfileModel get profileModel => _profile.value;
  set profileModel(ProfileModel pm) => _profile.value = pm;

  Future<bool> createProfile(ProfileModel profileModel) async {
    // digunakan untuk menambahkan data profile kedalam collection "profile" di firesotre
    try {
      profileCollection.doc(profileModel.uid).set({
        "uid": profileModel.uid,
        "email": profileModel.email,
        "lang": "en",
        "theme": "light",
        "image_url": "",
        "city": profileModel.city,
        "name": profileModel.name,
        "search": caseSearch(
            profileModel.email! + " " + profileModel.name!.toLowerCase()),
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<ProfileModel> profileUser(String uid) async {
    // digunakan untuk mendapatkan data profile dari firesotre pada saat user belum login
    try {
      DocumentSnapshot doc = await profileCollection.doc(uid).get();
      return ProfileModel.doc(doc);
    } catch (e) {
      rethrow;
    }
  }

  getProfileUser(String uid) {
    // digunakan untuk mendapatkan data profile pada saat user sudah login dan disimpan pada app controller
    return profileUser(uid).then((value) => profileModel = value);
  }

  resetProfile() {
    //digunakan untuk mereset data profile di app controller,
    //supaya tidak tersimpan apabila ada user baru yang login pada device yang sama
    _profile.value = ProfileModel();
    profileModel = ProfileModel();
  }

  @override
  void onInit() {
    super.onInit();
    // berfungsi untuk mendapatkan mengecek user sedang login atau tidak,
    // pengecekan ini berlangsung secara realtime
    _user.bindStream(auth.authStateChanges());
  }
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AppController(), permanent: true);
    Get.put(AuthController());
    Get.put(HomeController());
  }
}
