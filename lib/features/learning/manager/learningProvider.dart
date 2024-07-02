import 'package:flutter/material.dart';

class LearningProvider extends ChangeNotifier {
  List<bool> _isVisible = [false, false, false, false];
  List<bool> get isVisible => _isVisible;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  void changeVisibility(int index) {
    _isVisible[index] = !_isVisible[index];
    notifyListeners();
  }
}
