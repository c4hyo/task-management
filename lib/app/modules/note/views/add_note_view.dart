import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:yo_task_managements/app/data/models/notes.dart';
import 'package:yo_task_managements/app/modules/note/controllers/note_controller.dart';

import '../../../config/theme.dart';

class AddNoteView extends GetView<NoteController> {
  final title = TextEditingController();
  final description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Get.bottomSheet(
                Container(
                  padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
                  color: Get.theme.scaffoldBackgroundColor,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: listColor.length,
                    itemBuilder: (_, i) {
                      return ListTile(
                        onTap: () {
                          controller.colorTemp.value = listColor[i]['color'];
                          Get.back();
                        },
                        title: Text("${listColor[i]['color']}"),
                        leading: CircleAvatar(
                          backgroundColor: listColor[i]['colorData'],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            child: Obx(
              () => CircleAvatar(
                backgroundColor: cardColor(controller.colorTemp.value),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: ListView(
          children: [
            TextFormField(
              // controller dari email, atau variabel email
              controller: title,
              // keyboard pada saat menekan form ini menjadi tipe email
              style: TextStyle(
                color: darkText,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                hintText: "Title",
                hintStyle: TextStyle(
                  color: darkText,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                border: InputBorder.none, // form ini tidak berborder
                // icon pada sebelah kiri form
              ),
            ),
            // memberi spasi antar widget sebesar 20% dari lebar layar
            Divider(
              color: darkText,
              thickness: 1,
            ),
            TextFormField(
              // controller dari email, atau variabel email
              controller: description,
              maxLines: null,
              style: TextStyle(
                color: primaryColor,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                hintText: "Description",
                hintStyle: TextStyle(
                  color: darkText,
                ),
                border: InputBorder.none, // form ini tidak berborder
                // icon pada sebelah kiri form
              ),
            ),
            // memberi spasi antar widget sebesar 20% dari lebar layar
            SizedBox(
              height: Get.size.width * 0.02,
            ),

            ElevatedButton(
              onPressed: () {
                NotesModel nm = NotesModel(
                  color: controller.colorTemp.value,
                  createdAt: DateTime.now().toIso8601String(),
                  description: description.text,
                  ownerId: controller.profilNote.value.uid,
                  title: title.text,
                  notesId: Uuid().v1(),
                );
                controller.addNote(nm);
                Get.back();
              },
              child: Text("Add Notes"),
            ),
          ],
        ),
      ),
    );
  }
}
