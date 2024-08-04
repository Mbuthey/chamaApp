import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chama/screens/LoginScreen.dart';
import 'package:chama/screens/UserDashboard.dart';
import 'package:chama/utils/constants.dart';
import 'package:chama/utils/toast_util.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chama/services/firebase_service.dart';

class SignUpWithEmail extends StatefulWidget {
  const SignUpWithEmail({super.key});

  @override
  _SignUpWithEmailState createState() => _SignUpWithEmailState();
}

class _SignUpWithEmailState extends State<SignUpWithEmail> {
  final FirebaseService _firebaseService = FirebaseService();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;

  Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // If successful, store additional user data in Firestore
      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'first_name':
              userCredential.user!.displayName?.split(' ').first ?? '',
          'last_name': userCredential.user!.displayName?.split(' ').last ?? '',
          'email': userCredential.user!.email,
          'created_at': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        // Save user data to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', userCredential.user!.uid);
        await prefs.setString('email', userCredential.user!.email ?? '');
        await prefs.setString('first_name',
            userCredential.user!.displayName?.split(' ').first ?? '');
        await prefs.setString('last_name',
            userCredential.user!.displayName?.split(' ').last ?? '');

        // Navigate to UserDashboard
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const UserDashboard()),
            (route) => false);
      }
    } catch (e) {
      print(e);
      displayToastMessage(context, "Error signing in with Google: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          color: Constants.colorPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 40),
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
                            const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        prefixIcon: const Icon(Icons.person),
                        hintText: "Enter first name",
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.textColorGrey))),
                  ),
                  const SizedBox(height: 10),
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
                            const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        prefixIcon: const Icon(Icons.person),
                        hintText: "Enter last name",
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.textColorGrey))),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Email address",
                    style: TextStyle(
                        color: Constants.textColorGrey,
                        fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        filled: false,
                        contentPadding:
                            const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        prefixIcon: const Icon(Icons.email),
                        hintText: "Enter Email",
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.textColorGrey))),
                  ),
                  const SizedBox(height: 10),
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
                            const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        prefixIcon: const Icon(Icons.assignment_ind_sharp),
                        hintText: "Enter ID/Passport Number",
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.textColorGrey))),
                  ),
                  const SizedBox(height: 10),
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
                            const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        prefixIcon: const Icon(Icons.lock),
                        hintText: "Password",
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.textColorGrey))),
                  ),
                  const SizedBox(height: 10),
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
                            const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        prefixIcon: const Icon(Icons.lock),
                        hintText: "Confirm Password",
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Constants.textColorGrey))),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black)),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            if (validateInputs()) {
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
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black)),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: MaterialButton(
                                  minWidth: double.infinity,
                                  height: 60,
                                  onPressed:
                                      signInWithGoogle, // This line changes
                                  color: Constants.colorPrimary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                          'assets/images/googleicon.png',
                                          fit: BoxFit.cover),
                                      const SizedBox(width: 5.0),
                                      Text(
                                        isLoading
                                            ? "Signing in..."
                                            : "Sign up with Google",
                                        style: Constants.boldTextStyle(
                                            Constants.textColorBlack, 18.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          color: Constants.colorPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/googleicon.png',
                                  fit: BoxFit.cover),
                              const SizedBox(width: 5.0),
                              Text(
                                  isLoading
                                      ? "Registering..."
                                      : "Sign up with Google",
                                  style: Constants.boldTextStyle(
                                      Constants.textColorBlack, 18.0)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
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

  bool validateInputs() {
    if (firstNameController.text.isEmpty || lastNameController.text.isEmpty) {
      displayToastMessage(context, "Kindly fill all fields.");
      return false;
    } else if (!emailController.text.contains("@")) {
      displayToastMessage(context, "Email address is not valid.");
      return false;
    } else if (idController.text.isEmpty) {
      displayToastMessage(context, "National ID is required.");
      return false;
    } else if (passwordController.text.length < 6) {
      displayToastMessage(context, "Password must be at least 6 characters.");
      return false;
    } else if (passwordController.text != confirmPasswordController.text) {
      displayToastMessage(context, "Passwords do not match.");
      return false;
    }
    return true;
  }

Future<void> registerNewUser(BuildContext context) async {
  setState(() {
    isLoading = true;
  });

  try {
    // Use FirebaseService to create user and store data in Firestore
    await _firebaseService.signUpUser(
      emailController.text.trim(),
      passwordController.text.trim(),
      firstNameController.text.trim(),
      lastNameController.text.trim(),
      idController.text.trim(),
    );

    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Save user data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', user.uid);
      await prefs.setString('email', emailController.text.trim());
      await prefs.setString('first_name', firstNameController.text.trim());
      await prefs.setString('last_name', lastNameController.text.trim());

      // Navigate to UserDashboard
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const UserDashboard()),
        (route) => false
      ).catchError((error) {
        print("Error navigating to UserDashboard: $error");
        // Handle navigation error, perhaps by showing an error message
        displayToastMessage(context, "Error loading dashboard. Please try again.");
      });
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      displayToastMessage(context, "The password provided is too weak.");
    } else if (e.code == 'email-already-in-use') {
      displayToastMessage(context, "The account already exists for that email.");
    } else {
      displayToastMessage(context, "Error: ${e.message}");
    }
  } catch (e) {
     print("Unexpected error: $e");
    displayToastMessage(context, "An unexpected error occurred. Please try again.");
  } finally {
    setState(() {
      isLoading = false;
    });
    }
  }
}
