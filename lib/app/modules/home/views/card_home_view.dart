import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:yo_task_managements/app/config/collection.dart';
import 'package:yo_task_managements/app/config/helper.dart';
import 'package:yo_task_managements/app/config/theme.dart';
import 'package:yo_task_managements/app/data/models/profile.dart';
import 'package:yo_task_managements/app/data/models/task.dart';
import 'package:yo_task_managements/app/widget/card_user.dart';

// card untuk task tipe tim
Widget cardTaskTeam(TaskModel task) {
  return Card(
    child: Container(
      // memberi padding kiri kanan 15 dan atas bawah 10
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      //lebar container berdasarkan lebar layar device
      width: Get.size.width,
      child: Column(
        // konten di dalam widget terletak di sebelah kiri layar
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // judul task
          Text(
            task.title!.capitalize!,
            //maksimal baris 2
            maxLines: 2,

            softWrap: true,
            // teks yang berlebihan akan menjadi titik2
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              //teks jadi bold
              fontWeight: FontWeight.bold,
              // ukuran font sebesar 25
              fontSize: 25,
            ),
          ),

          //stream data dari firestore dengan return profile model
          StreamBuilder<ProfileModel>(
            stream: profileCollection
                .doc(task.ownerId)
                .snapshots()
                .map((value) => ProfileModel.doc(value)),
            builder: (_, s) {
              if (!s.hasData) {
                return Text("By: ");
              }
              // nama pemilik task
              return Text(
                "By: ${s.data!.name.toString().capitalize}",
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  // teks jadi miring atau italic
                  fontStyle: FontStyle.italic,
                  // teks jadi tebal sebesar w500
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
          // memberi spasi atar widget sebesar 5
          SizedBox(
            height: 5,
          ),
          Row(
            // meletakan widget di awal dan diakhir row
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                // meletakan widget di sebelah kiri layar
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // widget berbentuk lingkaran dengan backround berdasarkan warna task
                      CircleAvatar(
                        backgroundColor: cardColor(task.color!),
                        child: Icon(
                          FontAwesome5.calendar_alt, // ikon kalender
                          color: darkText, // warna icon gelap
                        ),
                      ),
                      // memberi spasi atar widget sebesar 5
                      SizedBox(
                        width: 5,
                      ),
                      // teks tanggal mulai dengan format MM DD, YYYY
                      Text(
                        date(task.startDate),
                      ),
                    ],
                  ),
                  // memberi spasi atar widget sebesar 10
                  SizedBox(
                    height: 10,
                  ),
                  Text("Team member"),
                  // menampilkan daftar anggota task tersebut
                  Container(
                    // tinggi konten sebesar 50
                    height: 50,
                    // memecahkan data anggota
                    child: ListView.builder(
                      // membuat konten sebesar data yang ada.
                      shrinkWrap: true,
                      // scroll android
                      physics: ClampingScrollPhysics(),
                      // list ditampilkan secara horizontal atau menyamping
                      scrollDirection: Axis.horizontal,
                      // jika banyak member kurang dari 4,
                      // maka menggunakan banyak data tersebut,
                      // apabila lebih dari 4 maka akan ada 4 data yang tampil
                      itemCount:
                          task.member!.length < 4 ? task.member!.length : 4,
                      itemBuilder: (_, i) {
                        // dikarenakan data maksimal yang tampil ada 4,
                        // maka data terakhir akan dibuat untuk menampilkan sisa anggota yang belum tampil
                        if (i == 3) {
                          return CircleAvatar(
                            backgroundColor: secondaryColorAccent,
                            child: Text(
                              (task.member!.length - 3).toString() + "+",
                              style: TextStyle(
                                color: darkText,
                              ),
                            ),
                          );
                        } else {
                          // digunakan unuk menampilkan data anggota,
                          // ditampilkan dengan foto profil user,
                          // apabila tidak ada foto profil akan ditampilakn lingkaran saja
                          return StreamBuilder<ProfileModel>(
                            stream: profileCollection
                                .doc(task.member![i])
                                .snapshots()
                                .map((value) => ProfileModel.doc(value)),
                            builder: (_, s) {
                              if (!s.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    left: 2,
                                    right: 2,
                                  ),
                                  child: profilePicture("", radius: 20),
                                );
                              }
                              return s.data!.imageUrl == null
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        left: 2,
                                        right: 2,
                                      ),
                                      child: profilePicture("", radius: 20),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                        left: 2,
                                        right: 2,
                                      ),
                                      child: profilePicture(
                                        s.data!.imageUrl,
                                        radius: 20,
                                      ),
                                    );
                            },
                          );
                        }
                      },
                    ),
                  ),
                  Text(task.category!.capitalize!),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // menampilkan deadline task, (hari)
                  Chip(
                    backgroundColor: cardColor(task.color!),
                    label: Text(
                      dateDiff(DateTime.now().toIso8601String(), task.endDate)
                              .toString() +
                          " Days",
                      style: TextStyle(
                        color: darkText,
                      ),
                    ),
                  ),
                  // menampilkan persentasi total task dengan task yang selesai
                  // ditampilan dengan indikator lingkaran
                  CircularPercentIndicator(
                    radius: 30,
                    lineWidth: 4.0,
                    percent: taskIndicator(task.todoCount, task.todoFinish),
                    center: Text(
                      (taskIndicator(task.todoCount, task.todoFinish) * 100)
                              .toString() +
                          " %",
                    ),
                    progressColor: cardColor(task.color!),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // widget digunakan untuk menampilkan dan tidak menampilkan widget childnya
                  Visibility(
                    visible: task.todoCount != 0,
                    child: Text(
                        "${task.todoFinish}/${task.todoCount} Tasks"), // digunakan untuk menampilkan total task dan task yang selesai
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

// card untuk task tipe personal
// penjelasan mirip card task tim

Widget cardTaskPersonal(TaskModel task) {
  return Card(
    child: Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      width: Get.size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title!.capitalize!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
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
                height: 5,
              ),
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
                height: 15,
              ),
              Text(task.category!.capitalize!),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Chip(
                backgroundColor: cardColor(task.color!),
                label: Text(
                  dateDiff(DateTime.now().toIso8601String(), task.endDate)
                          .toString() +
                      " Days",
                  style: TextStyle(
                    color: darkText,
                  ),
                ),
              ),
              CircularPercentIndicator(
                radius: 30,
                lineWidth: 4.0,
                percent: taskIndicator(task.todoCount, task.todoFinish),
                center: Text(
                  (taskIndicator(task.todoCount, task.todoFinish) * 100)
                          .toString() +
                      " %",
                ),
                progressColor: cardColor(task.color!),
              ),
              SizedBox(
                height: 15,
              ),
              Visibility(
                visible: task.todoCount != 0,
                child: Text("${task.todoFinish}/${task.todoCount} Tasks"),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
