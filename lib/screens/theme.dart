import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color lightappbar = Color(0xFFFFFFFF);

class Themes {
  static final light = ThemeData(
    primaryColor: Colors.white,
    // primarySwatch: Colors.white,
      brightness: Brightness.light);

  static final dark =
      ThemeData(
    // primaryColor: Colors.black,

        // primarySwatch: Colors.black,
         brightness: Brightness.dark);
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.white : Colors.black));
}

TextStyle get HeadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.white : Colors.black));
}
