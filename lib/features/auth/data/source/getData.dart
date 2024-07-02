import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocksapp/features/auth/data/models/userModel.dart';
import 'package:stocksapp/features/auth/domain/manager/authProvider.dart';

class AuthDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createUser(
      {required BuildContext context,
      required UserModel user,
      required String password}) async {
    String result = 'User created Successfully';
    try {
      UserCredential credential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: user.email, password: password);
      UserModel userModel = UserModel(
          uid: credential.user!.uid,
          name: user.name,
          email: user.email,
          dob: user.dob);
      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set(userModel.toMap());
      print('user name is ${userModel.email}');
      Provider.of<AuthServiceProvider>(context, listen: false)
          .updateUserDetails(userModel);
    } catch (err) {
      result = 'error';
      print(err.toString());
    }
    return result;
  }

  Future<String> signOutUser() async {
    String result = 'signed out success';
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (err) {
      result = err.message!;
    }
    return result;
  }

  Future<String> loginUser(
      {required BuildContext context,
      required String email,
      required String password}) async {
    String result = 'login';
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(credential.user!.uid).get();
      Provider.of<AuthServiceProvider>(context, listen: false)
          .updateUserDetails(UserModel.fromJson(snapshot));
    } on FirebaseAuthException catch (err) {
      result = err.message!;
    }
    return result;
  }
}
