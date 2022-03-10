import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yo_task_managements/app/config/collection.dart';
import 'package:yo_task_managements/app/data/models/profile.dart';

class ProfileController extends GetxController {
  final profile = ProfileModel().obs;
  final friendCount = 0.obs;
  final taskTeamCount = 0.obs;
  final taskPersonalCount = 0.obs;

  final image = "".obs;
  final imageUrl = "".obs;

  updateProfile(ProfileModel pm, String? myId) async {
    await profileCollection.doc(myId).update({
      "name": pm.name,
      "city": pm.city,
    });
  }

  confirmFriend(String? myId, String? friendId) async {
    final date = DateTime.now().toIso8601String();
    await profileCollection
        .doc(myId)
        .collection("request-friend")
        .doc(friendId)
        .delete();
    await profileCollection
        .doc(friendId)
        .collection("sent-request")
        .doc(myId)
        .delete();
    await profileCollection
        .doc(friendId)
        .collection("friend")
        .doc(myId)
        .set({"created_at": date});
    await profileCollection
        .doc(myId)
        .collection("friend")
        .doc(friendId)
        .set({"created_at": date});
  }

  Stream<int> getCountFriend(myId) {
    return profileCollection
        .doc(myId)
        .collection("friend")
        .snapshots()
        .map((event) => event.docs.length);
  }

  Stream<int> getTaskTeam(myId) {
    return taskCollection
        .where("member", arrayContains: myId)
        .where("type", isEqualTo: "team")
        .snapshots()
        .map((event) => event.docs.length);
  }

  Stream<int> getTaskPersonal(myId) {
    return taskCollection
        .where("member", arrayContains: myId)
        .where("type", isEqualTo: "personal")
        .snapshots()
        .map((event) => event.docs.length);
  }

  getImage(ImageSource source) async {
    var img = await ImagePicker().pickImage(source: source);
    if (img != null) {
      image.value = img.path;
    }
  }

  resetImage() {
    image.value = "";
    imageUrl.value = "";
  }

  @override
  void onInit() {
    super.onInit();
    profile.value = profile(Get.arguments['profile']);
  }

  @override
  void onClose() {
    profile.value = profile(ProfileModel());
  }
}
