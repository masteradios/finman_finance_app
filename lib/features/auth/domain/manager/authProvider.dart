import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:stocksapp/features/auth/data/models/userModel.dart';
import 'package:stocksapp/features/auth/data/source/getData.dart';

import '../../../home/presentation/pages/homeScreen.dart';

class AuthServiceProvider extends ChangeNotifier {
  UserModel _userModel =
      UserModel(uid: '', name: '', email: '', dob: DateTime.now());
  UserModel get userModel => _userModel;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  void updateUserDetails(UserModel user) {
    _userModel = user;
    print('on provider ${_userModel.email}');
    notifyListeners();
  }

  Future<void> registerUser(
      {required BuildContext context,
      required UserModel user,
      required String password}) async {
    _isLoading = true;
    notifyListeners();

    _errorMessage = await AuthDataSource()
        .createUser(context: context, user: user, password: password);
    _isLoading = false;
    if (_errorMessage != 'error') {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => ShowCaseWidget(builder: (context) {
                    return HomeScreen();
                  })),
          (route) => false);
    }

    notifyListeners();
  }

  Future<void> signOut() async {
    _isLoading = true;
    _errorMessage = await AuthDataSource().signOutUser();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loginUser(
      {required BuildContext context,
      required String email,
      required String password}) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = await AuthDataSource()
        .loginUser(context: context, email: email, password: password);
    _isLoading = false;
    notifyListeners();
    if (_errorMessage != 'login') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Invalid Credentials!!')));
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => ShowCaseWidget(builder: (context) {
                  return HomeScreen();
                })),
        (route) => false,
      );
    }
  }
}
