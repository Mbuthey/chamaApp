import 'package:flutter/material.dart';

String _message = "";
customeAlertDialog(BuildContext context, route, String message) {
  _message = message;
  showAlertDialog(context, route);
}

showAlertDialog(BuildContext context, route) {
  // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // set up the buttons
  Widget cancelButton = TextButton(
      child: const Text("CANCEL"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      });
  Widget continueButton = TextButton(
    child: const Text("YES"),
    onPressed: () async {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      // await firebaseAuth.signOut();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => route), (route) => false);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Attention !!!"),
    content: Text(_message),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}