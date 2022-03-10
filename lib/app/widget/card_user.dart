import 'package:flutter/material.dart';
import 'package:yo_task_managements/app/config/theme.dart';
import 'package:yo_task_managements/app/data/models/profile.dart';

Widget cardUser(
  ProfileModel? model, {
  bool? showActionButton,
  Function()? onTap,
  String? functionsName,
}) {
  return Card(
    child: Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                profilePicture(model!.imageUrl, radius: 30),
                Visibility(
                  visible: showActionButton!,
                  child: ElevatedButton(
                    onPressed: onTap,
                    child: Text(functionsName!),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            model.name!.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          Text(model.email!),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    ),
  );
}

Widget profilePicture(String? imageUrl, {double? radius}) {
  return imageUrl!.isEmpty
      ? CircleAvatar(
          radius: radius ?? 20,
          backgroundColor: primaryColor,
        )
      : CircleAvatar(
          radius: radius ?? 20,
          backgroundImage: NetworkImage(imageUrl),
          backgroundColor: primaryColor,
        );
}
