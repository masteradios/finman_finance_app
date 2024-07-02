// Creating dummy content for chapters

import 'dart:convert';
import 'package:flutter/material.dart';
import 'features/learning/data/models/chapter.dart';
import 'features/learning/data/models/level.dart';
import 'package:http/http.dart' as http;

Chapter chapter1Level1 = Chapter(
  isLast: false,
  chapterNumber: 1,
  title: "Basics of Budgeting",
  content:
      "Budgeting is the process of creating a plan to spend your money. This plan is called a budget. It allows you to determine in advance whether you will have enough money to do the things you need to do or would like to do.",
);

Chapter chapter2Level1 = Chapter(
  isLast: true,
  chapterNumber: 2,
  title: "Understanding Savings",
  content:
      "Savings is the portion of income not spent on current expenditures. By saving money, you can accumulate funds for future needs, emergencies, and investments.",
);

Chapter chapter1Level2 = Chapter(
  isLast: false,
  chapterNumber: 1,
  title: "Investing Fundamentals",
  content:
      "Investing is the act of allocating resources, usually money, with the expectation of generating an income or profit. Common forms of investing include purchasing stocks, bonds, real estate, and mutual funds.",
);

Chapter chapter2Level2 = Chapter(
  isLast: true,
  chapterNumber: 2,
  title: "Retirement Planning",
  content:
      "Retirement planning involves determining retirement income goals and the actions and decisions necessary to achieve those goals. It includes identifying sources of income, estimating expenses, implementing a savings program, and managing assets and risk.",
);

Chapter chapter1Level3 = Chapter(
  isLast: false,
  chapterNumber: 1,
  title: "Introduction to Credit",
  content:
      "Credit is a way to obtain goods or services before payment, based on the trust that payment will be made in the future. Understanding how credit works and how to manage it is essential for financial health.",
);

Chapter chapter2Level3 = Chapter(
  isLast: true,
  chapterNumber: 2,
  title: "Types of Credit",
  content:
      "There are various types of credit available, including credit cards, personal loans, and mortgages. Each type of credit has its own terms, interest rates, and repayment schedules.",
);

Chapter chapter1Level4 = Chapter(
  isLast: false,
  chapterNumber: 1,
  title: "Introduction to Risk Management",
  content:
      "Risk management involves identifying, assessing, and controlling threats to an organization's capital and earnings. These risks could stem from a variety of sources including financial uncertainty, legal liabilities, strategic management errors, accidents, and natural disasters.",
);

Chapter chapter2Level4 = Chapter(
  isLast: true,
  chapterNumber: 2,
  title: "Types of Risks",
  content:
      "There are various types of risks including market risk, credit risk, operational risk, and reputational risk. Each type of risk needs to be managed with appropriate strategies and tools to minimize potential negative impacts.",
);

// Creating levels with the chapters
Level level1 = Level(
  levelNumber: 1,
  title: "Introduction to Financial Literacy",
  chapters: [chapter1Level1, chapter2Level1],
);

Level level2 = Level(
  levelNumber: 2,
  title: "Advanced Financial Strategies",
  chapters: [chapter1Level2, chapter2Level2],
);
Level level3 = Level(
  levelNumber: 3,
  title: "Understanding Credits",
  chapters: [chapter1Level3, chapter2Level3],
);
Level level4 = Level(
  levelNumber: 4,
  title: "Risk Management",
  chapters: [chapter1Level4, chapter2Level4],
);

List<Level> levels = [level1, level2, level3, level4];

List<Stocks> stockImages = [
  Stocks(
      name: 'TATASTEEL.NS',
      stockImage: 'https://www.tatasteel.com/images/tatasteel.png'),
  Stocks(
      name: 'RELIANCE.NS',
      stockImage:
          'https://1000logos.net/wp-content/uploads/2021/09/Reliance-Industries-Limited-Logo.png'),
  Stocks(
      name: 'M&M.NS',
      stockImage:
          'https://i.pinimg.com/736x/55/06/41/550641417b2581c308939400bd7a5467.jpg'),
  Stocks(
      name: 'INFY',
      stockImage:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTX_eMYq1JthpUXr_rb_MtLaMXwlK3WgeG34w&s'),
  Stocks(
      name: 'NVDA',
      stockImage: 'https://s3-symbol-logo.tradingview.com/nvidia--600.png'),
  Stocks(
      name: 'IOC.NS',
      stockImage:
          'https://1000logos.net/wp-content/uploads/2021/08/Indian-Oil-Emblem.png')
];

String host = 'http://<YOUR_IP>:3000';

void httpErrorHandle(
    {required http.Response res,
    required VoidCallback onSuccess,
    required BuildContext context}) {
  switch (res.statusCode) {
    case 200:
      onSuccess();
      break;
    default:
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonDecode(res.body)['message'])));
  }
}

Map<String, String> headers = {
  'Content-Type': 'application/json; charset=UTF-8',
};

class Stocks {
  final String name;
  final String stockImage;

  Stocks({required this.name, required this.stockImage});
}
// List<StockData> stocks = [
//   StockData(
//       name: 'Reliance',
//       dateTime: DateTime(2016, 01, 11),
//       open: 98.97,
//       high: 101.19,
//       low: 95.36,
//       close: 97.13),
//   StockData(
//       name: 'Reliance',
//       dateTime: DateTime(2016, 01, 18),
//       open: 98.41,
//       high: 101.46,
//       low: 93.42,
//       close: 101.42),
//   StockData(
//       name: 'Reliance',
//       dateTime: DateTime(2016, 01, 25),
//       open: 101.52,
//       high: 101.53,
//       low: 92.39,
//       close: 97.34),
//   StockData(
//       name: 'Reliance',
//       dateTime: DateTime(2016, 02, 01),
//       open: 96.47,
//       high: 97.33,
//       low: 93.69,
//       close: 94.02),
//   StockData(
//       name: 'Reliance',
//       dateTime: DateTime(2016, 02, 08),
//       open: 93.13,
//       high: 96.35,
//       low: 92.59,
//       close: 93.99),
//   StockData(
//       name: 'Reliance',
//       dateTime: DateTime(2016, 02, 15),
//       open: 91.02,
//       high: 94.89,
//       low: 90.61,
//       close: 92.04),
//   StockData(
//       name: 'Reliance',
//       dateTime: DateTime(2016, 02, 22),
//       open: 96.31,
//       high: 98.0237,
//       low: 98.0237,
//       close: 96.31),
//   StockData(
//       name: 'Reliance',
//       dateTime: DateTime(2016, 02, 29),
//       open: 99.86,
//       high: 106.75,
//       low: 99.65,
//       close: 106.01),
//   StockData(
//       name: 'Reliance',
//       dateTime: DateTime(2016, 03, 07),
//       open: 102.39,
//       high: 102.83,
//       low: 100.15,
//       close: 102.26),
//   StockData(
//       name: 'Reliance',
//       dateTime: DateTime(2016, 03, 14),
//       open: 101.91,
//       high: 106.5,
//       low: 101.78,
//       close: 105.92),
//   StockData(
//       name: 'Reliance',
//       dateTime: DateTime(2016, 03, 21),
//       open: 105.93,
//       high: 107.65,
//       low: 104.89,
//       close: 105.67),
//   StockData(
//       name: 'Reliance',
//       dateTime: DateTime(2016, 03, 28),
//       open: 106,
//       high: 110.42,
//       low: 104.88,
//       close: 109.99),
//   StockData(
//       name: 'Reliance',
//       dateTime: DateTime(2016, 04, 04),
//       open: 110.42,
//       high: 112.19,
//       low: 108.121,
//       close: 108.66),
//   StockData(
//       name: 'Reliance',
//       dateTime: DateTime(2016, 04, 11),
//       open: 108.97,
//       high: 112.39,
//       low: 108.66,
//       close: 109.85),
//   StockData(
//       name: 'Reliance',
//       dateTime: DateTime(2016, 05, 11),
//       open: 108.97,
//       high: 112.39,
//       low: 108.66,
//       close: 109.85),
// ];
