// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chama/screens/LoginScreen.dart';
import 'package:chama/screens/UserDashboard.dart';
import 'package:chama/utils/constants.dart';
import 'package:chama/utils/loader.dart';
import 'package:chama/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignUpWithPhone extends StatefulWidget {
  const SignUpWithPhone({super.key});

  @override
  _SignUpWithPhoneState createState() => _SignUpWithPhoneState();
}

class _SignUpWithPhoneState extends State<SignUpWithPhone> {
  // text editing controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  late Loader loader;
  bool isLoading = false;
  // adding firebase
  // final _firestore = FirebaseFirestore.instance;
  // final _auth = FirebaseAuth.instance;
  // //init User class
  // late UserAcount userAccount;
  //init firebase

  //initialize state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkLogginStatus();
  }

  //check if a user is logged in
//check logging status
  // void checkLogginStatus() async {
  //   if (await _auth.currentUser != null) {
  //     // signed in
  //     loadUserAccount();
  //   } else {
  //     if (kDebugMode) {
  //       print("Not Logged in");
  //     }
  //   }
  // }

  //load user data and navigate
  // void loadUserAccount() async {
  //   _firestore
  //       .collection('users')
  //       .doc(await _auth.currentUser!.email)
  //       .get()
  //       .then((value) => {
  //             setState(() {
  //               userAccount = new UserAcount.fromSnapshot(value);
  //               if (kDebugMode) {
  //                 print(userAccount.email);
  //               }
  //             }),
  //             displaySuccessToastMessage(
  //                 context, "Welcome ${userAccount.firstName}"),
  //             Navigator.pushAndRemoveUntil(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => HomeScreen()),
  //                 (route) => false)
  //           });
  // }

  @override
  Widget build(BuildContext context) {
    //hide status
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          color: Constants.colorPrimary,
          padding: EdgeInsets.symmetric(horizontal: 40),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "First Name",
                    style: TextStyle(
                        color: Constants.textColorGrey,
                        fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                        filled: false,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        prefixIcon: Icon(
                          Icons.person,
                        ),
                        hintText: "Enter first name",
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.textColorGrey))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Last Name",
                    style: TextStyle(
                        color: Constants.textColorGrey,
                        fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                        filled: false,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        prefixIcon: Icon(
                          Icons.person,
                        ),
                        hintText: "Enter last name",
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.textColorGrey))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Phone Number",
                    style: TextStyle(
                        color: Constants.textColorGrey,
                        fontWeight: FontWeight.bold),
                  ),
                  IntlPhoneField(
                    decoration: InputDecoration(
                        filled: false,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        prefixIcon: Icon(
                          Icons.email,
                        ),
                        hintText: "Enter Phone Number",
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.textColorGrey))),
                    initialCountryCode: 'KE',
                    onChanged: (phone) {
                      print(phone.completeNumber);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "ID Number/Passport",
                    style: TextStyle(
                        color: Constants.textColorGrey,
                        fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: idController,
                    decoration: InputDecoration(
                        filled: false,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        prefixIcon: Icon(
                          Icons.assignment_ind_sharp,
                        ),
                        hintText: "Enter ID/Passport Number",
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.textColorGrey))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Password",
                    style: TextStyle(
                        color: Constants.textColorGrey,
                        fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        filled: false,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        prefixIcon: Icon(
                          Icons.lock,
                        ),
                        hintText: "Password",
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.textColorGrey))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Confirm Password",
                    style: TextStyle(
                        color: Constants.textColorGrey,
                        fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        filled: false,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        prefixIcon: Icon(
                          Icons.lock,
                        ),
                        hintText: "Confirm Password",
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.textColorGrey))),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border(
                        bottom: BorderSide(color: Colors.black),
                        top: BorderSide(color: Colors.black),
                        left: BorderSide(color: Colors.black),
                        right: BorderSide(color: Colors.black),
                      )),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      if (firstNameController.text.length.isNaN ||
                          lastNameController.text.length.isNaN) {
                        displayToastMessage(context, "Kindly fill this field.");
                      } else if (!emailController.text.contains("@")) {
                        displayToastMessage(
                            context, "Email address is not valid.");
                      } else if (idController.text.isEmpty) {
                        displayToastMessage(
                            context, "National ID is required.");
                      } else if (passwordController.text.length < 6) {
                        displayToastMessage(
                            context, "Password must be at least 6 characters.");
                      } else if (passwordController.text !=
                          confirmPasswordController.text) {
                        displayToastMessage(context, "Passwords do not match.");
                      } else {
                        registerNewUser(context);
                      }
                    },
                    color: Constants.colorSecondary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(isLoading ? "Registering..." : "Sign up",
                        style: Constants.boldTextStyle(
                            Constants.textColorGrey, 18.0)),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? "),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Text(" Login",
                              style: Constants.normalTextStyle(
                                  Constants.colorSecondary, 18.0))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> registerNewUser(BuildContext context) async {
    showDialogue("Registering please wait...", context);
    try {
      // final User? user = (await _auth.createUserWithEmailAndPassword(
      //         email: emailController.text, password: passwordController.text))
      //     .user;

      // Map<String, dynamic> userDataMap = {
      //   "id": user!.uid,
      //   "email": emailController.text.trim(),
      //   "firstName": firstNameController.text.trim(),
      //   "idNumber": idController.text.trim(),
      //   "lastName": lastNameController.text.trim(),
      //   "location": "",
      //   "phoneNumber": "",
      //   "photoURL": ""
      // };

      displayToastMessage(context,
          "Congratulations! your account has been created successfully");

      //update user data to firestore
      // _firestore
      //     .collection('users')
      //     .doc(emailController.text.trim())
      //     .set(userDataMap);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => UserDashboard()),
          (route) => false);
    } catch (e) {
      hideDialogue(context);
      debugPrint(e.toString());
      Get.snackbar("Sign up failed", "Try again later",
          duration: Duration(seconds: 1));
    }
  }
}
