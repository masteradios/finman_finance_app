import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stocksapp/constants.dart';
import 'package:stocksapp/features/community/data/model/newsmodel.dart';

class NewService {
  Future<List<NewsModel>> getRssData(
      {required String url, required BuildContext context}) async {
    List<NewsModel> news = [];

    try {
      http.Response response = await http.post(Uri.parse(host + '/getrss'),
          headers: headers,
          body: jsonEncode({"url": 'https://www.livemint.com/rss/${url}'}));

      httpErrorHandle(
          res: response,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(response.body)['data'].length; i++) {
              news.add(
                  NewsModel.fromJson(jsonDecode(response.body)['data'][i]));
            }
          },
          context: context);
    } catch (err) {
      print(err);
    }
    return news;
  }
}
