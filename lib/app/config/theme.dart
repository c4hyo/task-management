import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color greenUi = Color.fromARGB(255, 122, 248, 153);
Color redUi = Color.fromARGB(255, 252, 135, 135);
Color blueUi = Color.fromARGB(255, 164, 198, 241);
Color yellowUi = Color.fromARGB(255, 241, 243, 117);
Color orangeUi = Color.fromARGB(255, 245, 203, 186);

Color lightText = Color.fromARGB(221, 221, 220, 220);
Color darkText = Colors.black87;

Color primaryColor = Color.fromARGB(255, 39, 88, 221);
Color primaryColorAccent = Color.fromARGB(255, 136, 163, 253);
Color secondaryColor = Color.fromARGB(255, 93, 95, 99);
Color secondaryColorAccent = Color.fromARGB(255, 176, 187, 194);

Color lightBackgroud = Color.fromARGB(255, 246, 252, 252);

cardColor(String color) {
  // digunakan untuk mengatur warna komponen card berdasarkan value "color" task tersebut
  if (color == "green") {
    return greenUi;
  } else if (color == "red") {
    return redUi;
  } else if (color == "blue") {
    return blueUi;
  } else if (color == "yellow") {
    return yellowUi;
  } else if (color == "orange") {
    return orangeUi;
  } else {
    return lightBackgroud;
  }
}

Color textTheme(bool isDark) {
  // digunakan untuk mengubah warna teks berdasarkan tema yang digunakan
  if (isDark == true) {
    return lightText;
  } else {
    return darkText;
  }
}

Color colorNote(bool finish) {
  // digunakan untuk memberi warna backgroud pada note berdasarkan apakah note tersebut sudah selesai atau belum
  if (finish == true) {
    return greenUi;
  } else {
    return secondaryColorAccent;
  }
}

Color textCard(String color) {
  if (color == "red" || color == "blue") {
    return lightText;
  } else {
    return darkText;
  }
}

List<Map<String, dynamic>> listColor = [
  {"color": "green", "colorData": greenUi},
  {"color": "red", "colorData": redUi},
  {"color": "blue", "colorData": blueUi},
  {"color": "yellow", "colorData": yellowUi},
  {"color": "orange", "colorData": orangeUi},
];

ElevatedButtonThemeData roundedButtonLight = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    side: BorderSide(color: primaryColor),
    primary: lightBackgroud,
    textStyle: TextStyle(
      color: primaryColor,
    ),
  ),
);
ButtonStyle bs = ButtonStyle(
  side: MaterialStateProperty.all(
    BorderSide(color: primaryColor),
  ),
  backgroundColor: MaterialStateProperty.all(lightBackgroud),
  textStyle: MaterialStateProperty.all(TextStyle(
    color: primaryColor,
  )),
);

ThemeData light = ThemeData(
  iconTheme: IconThemeData(color: primaryColor),
  scaffoldBackgroundColor: lightBackgroud,
  textTheme: GoogleFonts.poppinsTextTheme(),
  brightness: Brightness.light,
  primaryColor: primaryColor,
  colorScheme: ThemeData().colorScheme.copyWith(
        primary: primaryColor,
      ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    splashColor: primaryColorAccent,
    elevation: 0,
  ),
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(color: primaryColor),
    titleTextStyle: GoogleFonts.kaushanScript(
      color: primaryColor,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    centerTitle: true,
    actionsIconTheme: IconThemeData(
      color: primaryColor,
    ),
    elevation: 0.2,
    backgroundColor: lightBackgroud,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),
);

ThemeData dark = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
  brightness: Brightness.dark,
  primaryColor: secondaryColor,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primaryColorAccent,
    splashColor: primaryColor,
    elevation: 0,
  ),
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(color: secondaryColorAccent),
    titleTextStyle: GoogleFonts.kaushanScript(
      color: secondaryColorAccent,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    centerTitle: true,
    actionsIconTheme: IconThemeData(
      color: secondaryColorAccent,
    ),
    elevation: 0.2,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: secondaryColorAccent,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: primaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  ),
);
