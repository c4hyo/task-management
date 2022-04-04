import 'package:get/get.dart';
import 'package:yo_task_managements/app/config/collection.dart';
import 'package:yo_task_managements/app/data/models/notes.dart';
import 'package:yo_task_managements/app/data/models/profile.dart';

class NoteController extends GetxController {
  final profilNote = ProfileModel().obs;
  final listNote = <NotesModel>[].obs;
  final colorTemp = "blue".obs;

  addNote(NotesModel notesModel) async {
    await notesCollection.doc(notesModel.notesId).set(notesModel.toMap());
    listNote.insert(0, notesModel);

    listNote.refresh();
  }

  updateNote(NotesModel noteModel, int index) async {
    await notesCollection.doc(noteModel.notesId).update({
      "title": noteModel.title,
      "description": noteModel.description,
      "color": noteModel.color,
    });
    listNote[index].title = noteModel.title;
    listNote[index].color = noteModel.color;
    listNote[index].description = noteModel.description;
    listNote.refresh();
  }

  deleteNote(String notesId, int index) async {
    await notesCollection.doc(notesId).delete();
    listNote.removeAt(index);
    listNote.refresh();
  }

  getListNote(String uid) async {
    final doc = await notesCollection
        .where("ownerId", isEqualTo: uid)
        .orderBy("createdAt", descending: true)
        .get();
    listNote.value = List.from(doc.docs.map((e) => NotesModel.doc(e)));
  }

  @override
  void onInit() {
    profilNote.value = profilNote(Get.arguments['profile']);
    super.onInit();
  }

  @override
  void onClose() {
    profilNote.value = ProfileModel();
  }
}
