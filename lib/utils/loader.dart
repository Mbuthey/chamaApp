// ignore_for_file: import_of_legacy_library_into_null_safe, unnecessary_new

import 'package:chama/utils/constants.dart';
import 'package:flutter/material.dart';

import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class Loader {
  late BuildContext context;
  late ProgressDialog pr;
  // Loader(this.context) {
  //   pr = new ProgressDialog(context);
  //   //For normal dialog
  // }
}

void showDialogue(String message, BuildContext context) {
  ProgressDialog pr;
  pr = new ProgressDialog(context: context);
  pr.show(
      msg: message,
      borderRadius: 10.0,
      backgroundColor: Constants.bgColor,
      progressType: ProgressType.normal,
      elevation: 10.0,
      barrierDismissible: true,
      msgFontWeight: FontWeight.bold,
      progressBgColor: Constants.colorContainer,
      max: 100,
      msgColor: Constants.textColorBlack,
      msgFontSize: 19.0);
}

hideDialogue(context) {
  ProgressDialog pr;
  pr = new ProgressDialog(context: context);

  pr.close();
}
