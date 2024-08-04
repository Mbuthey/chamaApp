// ignore_for_file: prefer_const_constructors, constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Constants {
  static Color colorPrimary = Color(0xFFFefae0);
  static Color colorSecondary = Color.fromRGBO(3, 54, 23, 1);
  static Color textColor = Color.fromARGB(1, 30, 30, 30);
  static Color buttonTextColor = Color.fromRGBO(255, 255, 255, 1);
  static Color iconColor = Color.fromRGBO(255, 255, 255, 1);
  static Color iconColorBlack = Color.fromRGBO(0, 0, 0, 1);
  static Color textColorBlack = Color.fromRGBO(0, 0, 0, 1);
  static Color textColorGrey = Color.fromRGBO(128, 128, 128, 1);
  static Color bgLightBrown = Color.fromRGBO(250, 239, 208, 1);
  static Color bgDarkBrown = Color.fromRGBO(161, 61, 2, 1);
  static Color bgDarkGreen = Color.fromRGBO(40, 54, 24, 1);
  static Color bgColor = Color.fromRGBO(242, 242, 242, 1);
  static TextStyle boldTextStyle(fontColor, fontSize) => TextStyle(
      color: fontColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.bold,
      fontSize: fontSize);
  static TextStyle normalTextStyle(fontColor, fontSize) => TextStyle(
      color: fontColor,
      fontFamily: "Poppins",
      fontWeight: FontWeight.normal,
      fontSize: fontSize);
  static String appName = "chama";
  static Color colorRetainer = Color.fromRGBO(103, 110, 83, 1);
  static Color colorContainer = Color.fromRGBO(210, 218, 196, 1);
}
