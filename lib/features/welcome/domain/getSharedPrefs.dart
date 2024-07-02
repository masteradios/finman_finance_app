import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeProvider extends ChangeNotifier {
  bool _tutorialDone = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool get tutorialDone => _tutorialDone;

  Future<void> getSharedPref() async {
    _isLoading = true;
    notifyListeners();
    final sharedPrefs = await SharedPreferences.getInstance();
    _tutorialDone = (await sharedPrefs.getBool('tutorialDone'))!;
    _isLoading = false;
    notifyListeners();
  }
}
