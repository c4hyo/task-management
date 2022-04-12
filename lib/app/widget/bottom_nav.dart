import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:yo_task_managements/app/data/models/profile.dart';
import 'package:yo_task_managements/app/widget/card_user.dart';

import '../config/theme.dart';

Widget botNav(int index, ProfileModel profileModel, Function() onTap) {
  return ConvexAppBar(
    backgroundColor: secondaryColorAccent,
    style: TabStyle.textIn,
    items: [
      TabItem(
        icon: Icon(Icons.task),
        title: "Task",
      ),
      TabItem(
        icon: Icon(Icons.home),
        title: "Home",
      ),
      TabItem(
        icon: Icon(Icons.note),
        title: "Note",
      ),
      TabItem(
        icon: profilePicture(profileModel.imageUrl),
        title: "Profile",
      ),
    ],
    initialActiveIndex: index,
    onTap: (int i) => onTap,
  );
}
