import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stocksapp/features/community/data/model/newsmodel.dart';
import 'package:stocksapp/features/community/data/newsCategory.dart';
import 'package:stocksapp/features/community/data/source/getData.dart';

class CommunityProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int _currentNewsCategory = 0;
  int get currentNewsCategory => _currentNewsCategory;
  List<NewsModel>? _news;
  List<NewsModel>? get news => _news;

  void updateCurrentCategory({required int newValue}) {
    _currentNewsCategory = newValue;
    notifyListeners();
  }

  void getRssFeed({required BuildContext context}) async {
    _news = [];
    _isLoading = true;
    notifyListeners();
    _news = await NewService().getRssData(
        url: newsCategories[_currentNewsCategory], context: context);
    _isLoading = false;
    notifyListeners();
  }
}
