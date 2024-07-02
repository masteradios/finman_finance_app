import 'package:intl/intl.dart';

class StockData {
  final String name;
  final DateTime dateTime;
  final double open;
  final double close;
  final double high;
  final double low;

  StockData(
      {required this.dateTime,
      required this.open,
      required this.name,
      required this.close,
      required this.high,
      required this.low});

  factory StockData.fromJson(json) {
    DateFormat format = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
    DateTime dateTime = format.parse(json['Date']);
    return StockData(
        dateTime: dateTime,
        open: double.parse(json['Open'].toStringAsFixed(2)),
        name: json['name'],
        close: double.parse(json['Close'].toStringAsFixed(2)),
        high: double.parse(json['High'].toStringAsFixed(2)),
        low: double.parse(json['Low'].toStringAsFixed(2)));
  }
}
