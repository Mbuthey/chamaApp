import 'package:chama/screens/LoginScreen.dart';
import 'package:chama/utils/constants.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Constants.colorPrimary,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Image.asset(
                          "assets/images/landingpageellipseimage.png",
                          height: screenHeight * 0.3,
                          width: screenWidth * 0.4,
                        ),
                      ),
                      Image.asset(
                        "assets/images/landingpagepeopleimage.png",
                        height: screenHeight * 0.2,
                        width: screenWidth * 0.9,
                      ),
                      Text(
                        "Join the Circle",
                        style: Constants.boldTextStyle(
                            Constants.textColorBlack, screenWidth * 0.08),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                        child: Text(
                          "Circle up & grow together with the harambee spirit & modern management",
                          style: Constants.normalTextStyle(
                              Constants.textColorBlack, screenWidth * 0.05),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                              (route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                              Constants.colorSecondary, // Text color
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                screenWidth * 0.35, // Horizontal padding
                            vertical: screenHeight * 0.02, // Vertical padding
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18.0, // Text size
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10.0), // Rounded corners
                          ),
                        ),
                        child: const Text("Get Started"),
                      ),
                      SizedBox(
                          height:
                              screenHeight * 0.05), // Add some bottom padding
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
