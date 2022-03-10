import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final auth =
    FirebaseAuth.instance; // memanggil fungsi yang digunakan untuk authentikasi
CollectionReference profileCollection = FirebaseFirestore.instance
    .collection("profile"); // memanggile collection bernama "profile"
CollectionReference taskCollection = FirebaseFirestore.instance
    .collection("task"); // memanggil collection bernama "task"
CollectionReference categoryCollection = FirebaseFirestore.instance
    .collection("category"); // memanggil collection bernama "category"
