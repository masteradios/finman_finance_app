import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stocksapp/constants.dart';

import '../../trade/data/models/stock.dart';

class SocketProvider extends ChangeNotifier {
  List<SocketUser> _socketUsers = [];
  List<SocketUser> get socketUsers => _socketUsers;
  List<String> _socketMessages = [];
  List<String> get socketMessages => _socketMessages;
  bool _game_begin = false;
  bool get game_begin => _game_begin;
  ScrollController controller = ScrollController();
  String _username = '';
  String get username => _username;
  bool _isWaiting = false;
  bool get iswaiting => _isWaiting;
  double _currentPrice = 0;
  double get currentPrice => _currentPrice;
  List<MyPortFolioItem> _myPortFolioItems = [];
  List<MyPortFolioItem> get myPortFolioItems => _myPortFolioItems;
  bool _isItemPresent = false;
  bool get isItemPresent => _isItemPresent;
  void addToMyPortFolio({required MyPortFolioItem portFolioItem}) {
    _myPortFolioItems.add(portFolioItem);
    notifyListeners();
  }

  MyPortFolioItem? getCurrentPortFolioItem({required String stockName}) {
    //MyPortFolioItem item=MyPortFolioItem(stockName: '', isBuying: true);
    for (int i = 0; i < _myPortFolioItems.length; i++) {
      if (_myPortFolioItems[i].stockName == stockName) {
        return _myPortFolioItems[i];
      }
    }
    return null;
  }

  void removeCurrentPortfolioItem({required String stockName}) {
    _myPortFolioItems.removeWhere((item) => item.stockName == stockName);
    notifyListeners();
  }

  void ItemPresent({required MyPortFolioItem item}) {
    _isItemPresent = false;
    notifyListeners();
    for (int i = 0; i < _myPortFolioItems.length; i++) {
      if (item.stockName == _myPortFolioItems[i].stockName) {
        _isItemPresent = true;
        return;
      } else {
        _isItemPresent = false;
      }
    }
    notifyListeners();
  }

  void updateMessage({
    required bool isGameBegin,
  }) {
    _game_begin = isGameBegin;

    notifyListeners();
  }

  void updateDetails({required SocketUser user, String? message}) {
    _socketUsers.add(user);
    _socketMessages.add(message!);
    notifyListeners();
    _scrollDown();
  }

  void isWaiting({required bool isWaiting}) {
    _isWaiting = isWaiting;
    notifyListeners();
  }

  void updateCurrentPrice({required double newPrice}) {
    _currentPrice = newPrice;
    notifyListeners();
  }

  void deleteTransactions() {
    _socketUsers = [];
    notifyListeners();
  }

  void _scrollDown() {
    controller.jumpTo(controller.position.maxScrollExtent);
  }
}

class SocketUser {
  String username;
  double profit;
  List<PortFolioItem>? portfolio;
  SocketUser({required this.username, required this.profit, this.portfolio});

  factory SocketUser.fromMap(Map<String, dynamic> data) {
    return SocketUser(
        username: data['username'],
        profit: data['points'],
        portfolio: data['portfolio']);
  }
}

class PortFolioItem {
  String stockName;
  double currentPrice;
  PortFolioItem({this.stockName = '', this.currentPrice = 0});
}

class MyPortFolioItem {
  final String stockName;
  final double? buyingPrice;
  final double? sellingPrice;
  final bool isBuying;

  MyPortFolioItem(
      {required this.stockName,
      this.buyingPrice,
      this.sellingPrice,
      required this.isBuying});
}
