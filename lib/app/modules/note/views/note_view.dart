import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:yo_task_managements/app/config/theme.dart';
import 'package:yo_task_managements/app/data/models/notes.dart';

import '../bindings/note_binding.dart';
import '../controllers/note_controller.dart';
import 'add_note_view.dart';

class NoteView extends GetView<NoteController> {
  final title = TextEditingController();
  final description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    controller.getListNote(controller.profilNote.value.uid!);
    return Scaffold(
      appBar: AppBar(
        title: Text('All Notes'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                () => AddNoteView(),
                arguments: {"profile": controller.profilNote.value},
                binding: NoteBinding(),
              );
            },
            icon: Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: ListView(
          children: [
            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: controller.listNote.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                    ),
                    child: Slidable(
                      child: cardNotes(controller.listNote[index], index),
                      endActionPane: ActionPane(
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) {
                              controller.deleteNote(
                                controller.listNote[index].notesId!,
                                index,
                              );
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete_forever,
                            label: 'Delete',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardNotes(NotesModel notesModel, int index) {
    return InkWell(
      onTap: () {
        title.text = notesModel.title!;
        description.text = notesModel.description!;
        controller.colorTemp.value = notesModel.color!;
        Get.dialog(
          Dialog(
            child: Container(
              padding: EdgeInsets.all(10),
              child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            NotesModel nm = NotesModel(
                              description: description.text,
                              notesId: notesModel.notesId,
                              title: title.text,
                              color: controller.colorTemp.value,
                            );
                            controller.updateNote(nm, index);
                            Get.back();
                          },
                          child: Text("Update Notes"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: InkWell(
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
                                        controller.colorTemp.value =
                                            listColor[i]['color'];
                                        Get.back();
                                      },
                                      title: Text("${listColor[i]['color']}"),
                                      leading: CircleAvatar(
                                        backgroundColor: listColor[i]
                                            ['colorData'],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                          child: Obx(
                            () => CircleAvatar(
                              backgroundColor:
                                  cardColor(controller.colorTemp.value),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(20),
        color: cardColor(notesModel.color!),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notesModel.title!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              color: darkText,
              thickness: 1,
            ),
            Text(notesModel.description!),
          ],
        ),
      ),
    );
  }
}
