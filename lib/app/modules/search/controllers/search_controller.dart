import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:yo_task_managements/app/config/collection.dart';
import 'package:yo_task_managements/app/data/models/task.dart';

class SearchController extends GetxController {
  String? type;
  var search = "".obs;
  bool isFriendRequest = false;
  bool isFriend = false;

  Stream<QuerySnapshot> searchCase(String search) {
    if (type == "task") {
      return taskCollection.where("code", isEqualTo: search).snapshots();
    } else {
      return profileCollection
          .where("search", arrayContains: search)
          .snapshots();
    }
  }

  bool myTask(TaskModel? task, String? uid) {
    return task!.ownerId == uid;
  }

  bool reqCheck(String? myId, String friendId) {
    profileCollection
        .doc(friendId)
        .collection("request-friend")
        .doc(myId)
        .get()
        .then((value) => isFriendRequest = value.exists);
    return isFriendRequest;
  }

  bool friendCheck(String? myId, String friendId) {
    profileCollection
        .doc(friendId)
        .collection("friend")
        .doc(myId)
        .get()
        .then((value) => isFriend = value.exists);
    return isFriend;
  }

  @override
  void onInit() {
    super.onInit();
    type = Get.arguments['type'];
  }

  @override
  void onClose() {
    type = "";
  }
}
