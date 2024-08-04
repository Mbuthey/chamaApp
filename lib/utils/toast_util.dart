import 'package:chama/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void displayToastMessage(BuildContext context, String message) {
  Fluttertoast.showToast(msg: message);
}

void displaySuccessToastMessage(BuildContext context, String message) {
  Fluttertoast.showToast(
      msg: message, backgroundColor: Constants.colorRetainer);
}

void displayErrorToastMessage(BuildContext context, String message) {
  Fluttertoast.showToast(msg: message, backgroundColor: Colors.redAccent);
}

