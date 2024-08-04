// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:chama/screens/ForgotPasswordScreen.dart';
import 'package:chama/screens/HomeScreen.dart';
import 'package:chama/screens/OnboardingScreen.dart';
import 'package:chama/screens/UserDashboard.dart';
import 'package:chama/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserDashboard()),
      );
    }
  }

  Future<void> handleLogin(BuildContext context) async {
    final email = emailController.text.trim();
    final passwordText = password.text.trim();

    if (email.isEmpty || passwordText.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter both email and password");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('https://portal.chamaroscas.com:6443/chama/auth');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'type': 'login',
          'email': email,
          'password': passwordText,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 200) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_id', responseData['user_id']);
          await prefs.setString('email', responseData['email']);
          await prefs.setString('first_name', responseData['first_name']);
          await prefs.setString('last_name', responseData['last_name']);
          await prefs.setString('wallet_id', responseData['wallet_id']);

          // Save groups data
          await prefs.setString('groups', jsonEncode(responseData['groups']));

          // Sign in to Firebase
          try {
            await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: email,
              password: passwordText,
            );
          } catch (e) {
            print("Firebase Auth Error: $e");
            // You might want to handle this error, but for now we'll continue
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UserDashboard()),
          );
        } else {
          Fluttertoast.showToast(
              msg: responseData['message'] ?? "Login failed");
        }
      } else {
        Fluttertoast.showToast(msg: "Server error: ${response.statusCode}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //hide status
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return Scaffold(
      backgroundColor: Constants.colorPrimary,
      body: LayoutBuilder(builder: (context, constraints) {
        var parentHeight = constraints.maxHeight;
        var parentWidth = constraints.maxWidth;
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              color: Constants.colorPrimary,
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Container(
                      width: parentWidth * .6,
                      height: parentHeight * 0.17,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                              image: AssetImage('assets/images/logo.png'),
                              fit: BoxFit.scaleDown))),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Login to your account",
                            style: Constants.boldTextStyle(
                                Constants.colorSecondary, parentHeight * .02),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Let's get to work",
                            style: Constants.normalTextStyle(
                                Constants.colorSecondary, parentHeight * .015),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Email",
                                style: TextStyle(
                                    color: Constants.textColorGrey,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                    filled: false,
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    prefixIcon: Icon(
                                      Icons.assignment_ind_sharp,
                                    ),
                                    hintText: "Enter Email",
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Constants.textColorGrey))),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text("Password",
                                  style: TextStyle(
                                      color: Constants.textColorGrey,
                                      fontWeight: FontWeight.bold)),
                              TextField(
                                controller: password,
                                obscureText: true,
                                decoration: InputDecoration(
                                    filled: false,
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                    ),
                                    hintText: "Enter Password",
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Constants.textColorGrey))),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ForgotPassword()));
                                      },
                                      child: Text(" Forgot Password ?",
                                          style: Constants.normalTextStyle(
                                              Constants.colorSecondary, 18.0))),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
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
                                      handleLogin(
                                          context); // Pass the context to the handleLogin function
                                    },
                                    color: Constants.colorSecondary,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                        isLoading ? "Processing..." : "Login",
                                        style: Constants.boldTextStyle(
                                            Constants.textColorGrey, 18.0)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Center(
                                  child: SizedBox(
                                    height: 40,
                                    child: Text(
                                      "OR",
                                      style: Constants.boldTextStyle(
                                          Constants.colorSecondary, 20.0),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
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
                                    onPressed: () =>
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomeScreen()),
                                            (route) => false),
                                    color: Constants.colorPrimary,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                            'assets/images/googleicon.png',
                                            fit: BoxFit.cover),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Text(
                                            isLoading
                                                ? "login in..."
                                                : "Login with Google",
                                            style: Constants.boldTextStyle(
                                                Constants.textColorBlack,
                                                18.0)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Don't have an account? "),
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OnboardingScreen()));
                                          },
                                          child: Text(" Sign Up",
                                              style: Constants.normalTextStyle(
                                                  Constants.colorSecondary,
                                                  18.0))),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
  // login user
}
