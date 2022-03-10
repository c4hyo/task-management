import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:yo_task_managements/app/config/collection.dart';
import 'package:yo_task_managements/app/config/theme.dart';
import 'package:yo_task_managements/app/controllers/app_controller.dart';
import 'package:yo_task_managements/app/data/models/profile.dart';
import 'package:yo_task_managements/app/data/models/task.dart';
import 'package:yo_task_managements/app/widget/card_search_task.dart';
import 'package:yo_task_managements/app/routes/app_pages.dart';
import 'package:yo_task_managements/app/widget/card_user.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  final myId = Get.find<AppController>().profileModel.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.type == "task" ? 'Join Task' : "Search User"),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(Get.size.width * 0.2),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
            child: TextFormField(
              autofocus: true,
              onChanged: (s) {
                if (controller.type == "task") {
                  controller.search.value = s.toUpperCase();
                } else {
                  controller.search.value = s;
                }
              },
              cursorColor: primaryColor,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: secondaryColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: secondaryColor,
                  ),
                ),
                filled: true,
                fillColor: secondaryColorAccent,
                hintText: "search".tr.capitalize!,
              ),
            ),
          ),
        ),
      ),
      body: Obx(
        () => (controller.search.isEmpty)
            ? Center(
                child: Text(
                  'Search ',
                  style: TextStyle(fontSize: 20),
                ),
              )
            : StreamBuilder<QuerySnapshot>(
                stream: controller.searchCase(controller.search.value),
                builder: (_, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (_, i) {
                      DocumentSnapshot doc = snapshot.data!.docs[i];
                      if (controller.type == "task") {
                        TaskModel model = TaskModel.doc(doc);
                        return cardSearchNote(
                          model,
                          controller.myTask(model, myId),
                          myId!,
                        );
                      } else {
                        ProfileModel model = ProfileModel.doc(doc);
                        return cardUser(
                          model,
                          functionsName: "Add friend",
                          onTap: () {
                            final date = DateTime.now().toIso8601String();
                            profileCollection
                                .doc(model.uid)
                                .collection("request-friend")
                                .doc(myId)
                                .set({"created_at": date});
                            profileCollection
                                .doc(myId)
                                .collection("sent-request")
                                .doc(model.uid)
                                .set({"created_at": date});
                          },
                          showActionButton: myId != model.uid &&
                              !controller.reqCheck(myId, model.uid!) &&
                              !controller.friendCheck(myId, model.uid!),
                        );
                      }
                    },
                  );
                },
              ),
      ),
    );
  }
}
