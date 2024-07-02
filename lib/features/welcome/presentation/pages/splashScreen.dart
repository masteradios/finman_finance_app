import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:stocksapp/features/auth/data/models/userModel.dart';
import 'package:stocksapp/features/auth/domain/manager/authProvider.dart';
import 'package:stocksapp/features/welcome/presentation/pages/authWelcomeScreen.dart';
import 'package:stocksapp/features/welcome/presentation/pages/firstScreen.dart';
import '../../../home/presentation/pages/homeScreen.dart';
import '../../domain/getSharedPrefs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? _tutorialDone = false;
  bool _isUserIn = false;

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  void getData() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    _tutorialDone = (await sharedPrefs.getBool('tutorialDone'));
    if (_tutorialDone != null) {
      _isUserIn = await getUserData();

      if (_isUserIn) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ShowCaseWidget(builder: (context) {
                      return HomeScreen();
                    })),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => AuthWelcomeScreen()),
            (route) => false);
      }
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => FirstScreen()),
          (route) => false);
    }
  }

  Future<bool> getUserData() async {
    bool isUserIn = false;
    try {
      User? user = await FirebaseAuth.instance.currentUser;

      if (user == null) {
        isUserIn = false;
      } else {
        isUserIn = true;
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        Provider.of<AuthServiceProvider>(context, listen: false)
            .updateUserDetails(UserModel.fromJson(snapshot));
      }
    } on FirebaseAuthException catch (err) {
      print('err on welcome: ${err.message}');
    }
    return isUserIn;
  }

  @override
  Widget build(BuildContext context) {
    final welcomeProvider = Provider.of<WelcomeProvider>(context);
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}
