import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yo_task_managements/app/config/collection.dart';
import 'package:yo_task_managements/app/config/upload.dart';
import 'package:yo_task_managements/app/modules/profile/controllers/profile_controller.dart';

class UploadPhotoView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Photo Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              if (controller.image.value == "") {
                controller.imageUrl.value == controller.profile.value.imageUrl!;
              } else {
                controller.imageUrl.value = await StorageServices.uploadImage(
                  fileImage: File(controller.image.value),
                  jenis: "profile-picture",
                  userId: controller.profile.value.uid,
                );
              }
              controller.profile.update((val) {
                val!.imageUrl = controller.imageUrl.value;
              });
              await profileCollection
                  .doc(controller.profile.value.uid)
                  .update({"image_url": controller.imageUrl.value});
              controller.resetImage();
              Get.back();
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Obx(
        () => InkWell(
          onTap: () {
            controller.getImage(
              ImageSource.gallery,
            );
            print(controller.image.value);
          },
          child: Center(
            child: Container(
              padding: EdgeInsets.all(10),
              width: Get.size.width,
              height: Get.size.width,
              child: controller.image.isNotEmpty
                  ? Stack(
                      children: [
                        Image.file(
                          File(controller.image.value),
                        ),
                        InkWell(
                          onTap: () => controller.image.value = "",
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.cancel,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  : controller.profile.value.imageUrl!.isNotEmpty
                      ? Image.network(controller.profile.value.imageUrl!)
                      : Center(
                          child: Icon(
                            Icons.image,
                            size: 85,
                          ),
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
