

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:stocksapp/features/expensetracker/data/source/getFile.dart';
import 'package:stocksapp/features/expensetracker/data/source/uploadFileToStorage.dart';

import '../data/models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;
  List<Expense> _aggregatedExpenses = [];
  List<Expense> get aggregatedExpenses => _aggregatedExpenses;
  double _totalAmountSpent = 0;
  double get totalAmountSpent => _totalAmountSpent;
  List<Expense> _categoryExpenses = [];
  List<Expense> get categoryExpenses => _categoryExpenses;
  int _currentCategory = 0;
  int get currentCategory => _currentCategory;

  DateTime? _pickedDate;
  DateTime? get pickedDate => _pickedDate;
  XFile? _image;
  XFile? get image => _image;
  String _formattedDate = '';
  String get formattedDate => _formattedDate;
  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void getExpenseData() async {
    _isLoading = true;
    notifyListeners();
    _expenses = await FirebaseStorageService().getExpenses();
    getAggregateExpenses();
    _isLoading = false;
    notifyListeners();
    if (_expenses.isEmpty) {
      print('Nothing found');
    }
  }

  void getAggregateExpenses() {
    Map<String, double> aggregatedExpenses = {};
    double totalAmountSpent = 0;
    List<Expense> aggregatedExpenseList = [];
    for (var expense in _expenses) {
      if (aggregatedExpenses.containsKey(expense.category)) {
        aggregatedExpenses[expense.category] =
            aggregatedExpenses[expense.category]! + expense.amount;
      } else {
        aggregatedExpenses[expense.category] = expense.amount;
      }
      totalAmountSpent = totalAmountSpent + expense.amount;
    }
    aggregatedExpenseList = aggregatedExpenses.entries
        .map((entry) => Expense(
            category: entry.key,
            amount: entry.value,
            dateTime: DateTime(2024, 01, 01)))
        .toList();
    _aggregatedExpenses = aggregatedExpenseList;
    _totalAmountSpent = totalAmountSpent;
    notifyListeners();
  }

  void getParticularExpenseCategory({required String category}) {
    _categoryExpenses = [];
    notifyListeners();
    for (var expense in _expenses) {
      if (expense.category == category) {
        _categoryExpenses.add(expense);
      }
    }
    notifyListeners();
  }

  void selectCategory({required int newCategoryIndex}) {
    _currentCategory = newCategoryIndex;
    notifyListeners();
  }

  void pickDate(DateTime? selectedDate) {
    _pickedDate = selectedDate;
    notifyListeners();
  }

  void formatDate() {
    DateFormat formatter = DateFormat.yMMMMd('en_US');
    _formattedDate = formatter.format(_pickedDate!);
    notifyListeners();
  }

  void getImage() async {
    _image = await FilePicker().pickFile();
    notifyListeners();
  }

  void uploadExpenseDetails(
      {required Expense expense, required BuildContext context}) async {
    _isLoading = true;
    print('in upload provider');
    notifyListeners();
    _errorMessage = await FirebaseStorageService()
        .uploadImage(imageFile: _image, expense: expense);
    _isLoading = false;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(_errorMessage)));
    _currentCategory = 0;
    _pickedDate = null;
    if (_errorMessage != 'error') {
      Navigator.pop(context);
    }
    getExpenseData();
    notifyListeners();
  }
}
