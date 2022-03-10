import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

import 'package:get/get.dart';

import '../config/collection.dart';
import '../config/helper.dart';
import '../config/theme.dart';
import '../data/models/profile.dart';
import '../data/models/task.dart';

Widget cardSearchNote(TaskModel task, bool myTask, String myId) {
  return Card(
    child: Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      width: Get.size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                task.title!.capitalize! + " ~ ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Visibility(
                visible: myTask,
                child: Text("My Task"),
              ),
            ],
          ),
          FutureBuilder<ProfileModel>(
            future: profileCollection
                .doc(task.ownerId)
                .get()
                .then((value) => ProfileModel.doc(value)),
            builder: (_, s) {
              if (!s.hasData) {
                return Text("By: ");
              }
              return Text(
                "By: ${s.data!.name.toString().capitalize}",
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: cardColor(task.color!),
                    child: Icon(
                      FontAwesome5.calendar_alt,
                      color: darkText,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    date(task.startDate),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    date(task.endDate),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  CircleAvatar(
                    backgroundColor: redUi,
                    child: Icon(
                      FontAwesome5.calendar_alt,
                      color: darkText,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Center(
            child: Visibility(
              visible: !myTask && !task.member!.contains(myId),
              child: ElevatedButton(
                onPressed: () {
                  taskCollection.doc(task.taskId).update({
                    "member": FieldValue.arrayUnion([myId])
                  });
                  Get.back();
                },
                child: Text("Join Task"),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
