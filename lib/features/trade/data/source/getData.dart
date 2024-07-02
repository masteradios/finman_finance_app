import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../constants.dart';
import '../models/stock.dart';

class TradeService {
  Future<List<StockData>> getStockData(
      {required String stockName,
      required String period,
      required BuildContext context}) async {
    String res = 'Success';
    List<StockData> stocks = [];
    try {
      http.Response res = await http.post(Uri.parse('${host}/getstocks'),
          headers: headers,
          body: jsonEncode({'stockName': stockName, "period": period}));
      httpErrorHandle(
          res: res,
          onSuccess: () {
            for (int i = 0; i < jsonDecode(res.body)['data'].length; i++) {
              stocks.add(StockData.fromJson(jsonDecode(res.body)['data'][i]));
            }
          },
          context: context);
    } catch (err) {
      print(err);
      res = 'error receiving data';
    }
    return stocks;
  }
}
