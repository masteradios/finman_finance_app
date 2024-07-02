import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stocksapp/features/trade/data/source/getData.dart';
import '../data/models/stock.dart';

class TradeProvider extends ChangeNotifier {
  int _currentStockIndex = 0;
  int get currentStockIndex => _currentStockIndex;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<StockData> _stocks = [];
  List<StockData> get stocks => _stocks;
  String _period = '3mo';
  String get period => _period;
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  void getStocksData(
      {required String stockName, required BuildContext context}) async {
    _stocks = [];
    _isLoading = true;
    notifyListeners();
    _stocks = await TradeService()
        .getStockData(stockName: stockName, period: _period, context: context);
    //notifyListeners();
    _isLoading = false;
    notifyListeners();
  }

  void updatePeriod({required String period}) {
    _period = period;
    notifyListeners();
  }

  void updateCurrentStock({required int newVal}) {
    _currentStockIndex = newVal;
    notifyListeners();
  }

  void updateStocks({required List<StockData> data}) {
    _stocks = [];
    notifyListeners();
    _stocks = data;
    notifyListeners();
  }
}
