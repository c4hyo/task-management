import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:yo_task_managements/app/config/collection.dart';
import 'package:yo_task_managements/app/config/theme.dart';
import 'package:yo_task_managements/app/data/models/profile.dart';
import 'package:yo_task_managements/app/modules/profile/controllers/profile_controller.dart';

class RequestFriendView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Friend'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: profileCollection
            .doc(controller.profile.value.uid)
            .collection("request-friend")
            .snapshots(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return Visibility(
              child: Text(""),
              visible: false,
            );
          }
          print(snapshot.data!.docs.length);
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (_, i) {
              return FutureBuilder<ProfileModel>(
                future: profileCollection
                    .doc(snapshot.data!.docs[i].id)
                    .get()
                    .then((value) => ProfileModel.doc(value)),
                builder: (_, s) {
                  if (!s.hasData) {
                    return ListTile();
                  }
                  ProfileModel profileModel = s.data!;
                  return Card(
                    elevation: 0.5,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: primaryColor,
                      ),
                      title: Text(profileModel.name!.capitalize!),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            color: primaryColor,
                            onPressed: () {
                              controller.confirmFriend(
                                controller.profile.value.uid,
                                profileModel.uid,
                              );
                            },
                            icon: Icon(
                              Icons.check_rounded,
                            ),
                          ),
                          IconButton(
                            color: redUi,
                            onPressed: () {},
                            icon: Icon(
                              Icons.cancel,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
