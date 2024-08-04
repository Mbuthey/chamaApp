// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables

import 'package:chama/utils/constants.dart';
import 'package:chama/views/SignUpWithPhone.dart';
import 'package:chama/views/SignUpWithEmail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  // introducing a tab controller to handle tab navigation
  late TabController _tabController;
  //set parentHeightController
  bool isSignupWithPhone = true;
  bool setUpSignUP = false;
  var _height;

  // creating an init state to initialize components during build
  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  // disposing of dynamic widgets after screen destruction
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //hide status
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return Scaffold(
      backgroundColor: Constants.colorPrimary,
      // implement a safearea for sufficient padding to avoid intrusions
      body: LayoutBuilder(builder: (context, constraints) {
        var parentHeight = constraints.maxHeight;
        var parentWidth = constraints.maxWidth;
        //parent column
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // column containing the logo and tagline

              AnimatedContainer(
                color: Constants.colorPrimary,
                // Use the properties stored in the State class.
                width: parentWidth,
                height: isSignupWithPhone
                    ? MediaQuery.of(context).size.height * .3
                    : _height,

                // Define how long the animation should take.
                duration: const Duration(seconds: 1),
                // Provide an optional curve to make the animation feel smoother.
                curve: Curves.fastOutSlowIn,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: parentWidth * .6,
                        height: parentHeight * 0.17,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            image: DecorationImage(
                                image: AssetImage('assets/images/logo.png'),
                                fit: BoxFit.scaleDown))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text(
                            "Sign Up",
                            style: Constants.boldTextStyle(
                                Constants.colorSecondary,
                                isSignupWithPhone
                                    ? parentHeight * .02
                                    : parentHeight * .02),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              //column containing the contents
              // creating a tab controller to handle navigation between login and signup
              Container(
                width: parentWidth,
                decoration: BoxDecoration(
                    color: Constants.colorPrimary,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          border: isSignupWithPhone
                              ? Border(
                                  bottom: BorderSide(
                                      width: 1, color: Constants.textColorGrey),
                                )
                              : null,
                        ),
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                isSignupWithPhone = true;
                                setUpSignUP = false;
                                _height = parentHeight * .4;
                              });
                            },
                            child: Text("Phone",
                                style: Constants.normalTextStyle(
                                    Constants.textColorBlack, 16.0)))),
                    Container(
                        decoration: BoxDecoration(
                          // underlining border
                          border: !isSignupWithPhone
                              ? Border(
                                  bottom: BorderSide(
                                      width: 1, color: Constants.textColorGrey),
                                )
                              : null,
                        ),
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                isSignupWithPhone = false;
                                _height = parentHeight * .2;
                              });
                            },
                            child: Text("Email",
                                style: Constants.normalTextStyle(
                                    Constants.textColorBlack, 16.0)))),
                  ],
                ),
              ),

              //display signup or login contents depending on clicked button
              isSignupWithPhone ? SignUpWithPhone() : SignUpWithEmail()
            ],
          ),
        );
      }),
    );
  }
}
