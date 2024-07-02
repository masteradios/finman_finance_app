import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stocksapp/features/expensetracker/data/models/expense.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImage(
      {required XFile? imageFile, required Expense expense}) async {
    print('into upload');
    String res = 'success';
    String downloadUrl = '';
    try {
      if (imageFile != null) {
        print('into image upload');

        String pid = Uuid().v1();
        Reference _ref = _storage
            .ref()
            .child('images')
            .child(_auth.currentUser!.email!)
            .child(pid);
        UploadTask uploadTask = _ref.putFile(File(imageFile.path));
        TaskSnapshot taskSnapshot = await uploadTask;
        downloadUrl = await taskSnapshot.ref.getDownloadURL();
        print('image url done');
      }
      // Create a reference to the location you want to upload to in Firebase Storage

      // Save the download URL to Firestore
      expense.imageUrl = downloadUrl;
      await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('expenses')
          .add(expense.toJson());

      print('File uploaded and metadata saved to Firestore.');
    } catch (e) {
      print(e);
      res = 'error';
    }
    return res;
  }

  Future<List<Expense>> getExpenses() async {
    List<Expense> expenses = [];
    try {
      QuerySnapshot snap = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('expenses')
          .get();

      for (int i = 0; i < snap.docs.length; i++) {
        expenses.add(Expense.fromJson(snap.docs[i]));
      }
    } catch (err) {
      print(err);
    }

    return expenses;
  }
}
