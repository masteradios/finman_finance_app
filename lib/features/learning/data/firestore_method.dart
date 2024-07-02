import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:stocksapp/features/auth/data/models/userModel.dart';
import 'package:stocksapp/features/auth/domain/manager/authProvider.dart';

class LearningService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<String> updateData(
      {required int newLevel,
      required int newChapter,
      required BuildContext context,
      required double myMoney}) async {
    String res = 'Success';
    try {
      await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'currentChapter': newChapter,
        'currentLevel': newLevel,
        'myMoney': myMoney + 50
      });

      DocumentSnapshot snapshot = await firestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .get();
      Provider.of<AuthServiceProvider>(context, listen: false)
          .updateUserDetails(UserModel.fromJson(snapshot));
      //_onBasicAlertPressed(context);
    } catch (err) {
      res = err.toString();
    }

    return res;
  }
}
