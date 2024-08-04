// ignore_for_file: prefer_const_constructors

import 'package:chama/utils/constants.dart';
import 'package:chama/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Back",
          style: Constants.normalTextStyle(Constants.textColorBlack, 20.0),
        ),
        elevation: 0,
        backgroundColor: Constants.colorPrimary,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: Constants.colorPrimary,
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "Forgot Password",
                        style: Constants.normalTextStyle(
                            Constants.colorSecondary, 30.0),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Enter email to reset your password",
                        style: Constants.normalTextStyle(
                            Constants.textColorBlack, 15.0),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Column(children: <Widget>[
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                                filled: false,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                prefixIcon: Icon(
                                  Icons.assignment_ind_sharp,
                                ),
                                hintText: "Enter Email",
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Constants.textColorGrey))),
                          ),
                          SizedBox(
                            height: 30.0,
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
                                onPressed: () {},
                                color: Constants.colorSecondary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                    isLoading
                                        ? "Processing..."
                                        : "Send Reset Link",
                                    style: Constants.boldTextStyle(
                                        Constants.textColorGrey, 18.0)),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Future<void> _resetPassword(String email) async {
    displaySuccessToastMessage(context, "Reset");
  }
}
