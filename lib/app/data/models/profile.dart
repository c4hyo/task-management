import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  String? uid;
  String? name;
  String? email;
  String? lang;
  String? theme;
  String? imageUrl;
  String? city;
  List<dynamic>? search;
  ProfileModel({
    this.uid,
    this.name,
    this.email,
    this.lang,
    this.theme,
    this.imageUrl,
    this.city,
    this.search,
  });

  ProfileModel.doc(DocumentSnapshot doc) {
    // digunakan untuk memecah data dari firestore menjadi sebuah variabel yang mudah digunakan
    uid = doc.id;
    name = doc['name'];
    email = doc['email'];
    lang = doc['lang'];
    theme = doc['theme'];
    imageUrl = doc['image_url'];
    city = doc['city'];
    search = doc['search'];
  }
}
