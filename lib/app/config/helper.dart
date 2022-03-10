import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yo_task_managements/app/config/theme.dart';

caseSearch(String judul) {
  // digunakan untuk mengurai nama dan email yang digunakan untuk fungsi pencarian pengguna
  //data ini akan disimapn di firestore
  List<String> caseSearch = [];
  String temp = "";
  for (var i = 0; i < judul.length; i++) {
    if (judul[i] == " ") {
      temp = "";
    } else {
      temp = temp + judul[i];
      caseSearch.add(temp);
    }
  }
  return caseSearch;
}

randomString() {
  // digunakan untuk mengenerate string,
  //contoh penggunaan pada generate code
  const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
  Random _rnd = Random();

  return String.fromCharCodes(Iterable.generate(8, (_) {
    return _chars.codeUnitAt(_rnd.nextInt(_chars.length));
  }));
}

date(String? date) {
  // digunakan untuk memformat tanggal
  return DateFormat.yMMMMd("en").format(DateTime.parse(date!));
}

dateDiff(String? start, String? end) {
  //digunakan untuk mencari selisih antara tanggal awal dengan tanggal akhir
  final a = DateTime.parse(start!);
  final b = DateTime.parse(end!);

  return b.difference(a).inDays;
}

Color deadlineColor(int days) {
  // digunakan untuk menentukan warna backgroud berdasarkan selisih hari
  if (days < 0) {
    return redUi;
  } else if (days == 0) {
    return orangeUi;
  } else {
    return yellowUi;
  }
}

String deadlineText(int days) {
  // digunakan untuk menampilkan "text" selisih hari
  if (days < 0) {
    return days == 1 ? "${days.abs()} day late" : "${days.abs()} days late";
  } else if (days == 0) {
    return "Deadline today";
  } else {
    return "$days Days";
  }
}

double taskIndicator(int? totalTask, int? taskFinish) {
  //digunakan untuk menampilkan nilai desimal
  return (totalTask == 0 && taskFinish == 0)
      ? 0
      : double.parse((taskFinish! / totalTask!).toStringAsFixed(2));
}
