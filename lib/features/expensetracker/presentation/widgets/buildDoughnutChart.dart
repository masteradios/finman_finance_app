import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../data/models/expense.dart';

Widget buildDoughnutChart(
    {required List<Expense> expenses, required double totalAmount}) {
  return SfCircularChart(
    margin: EdgeInsets.zero,
    centerX: '117',
    series: <DoughnutSeries<Expense, String>>[
      DoughnutSeries<Expense, String>(
        radius: '75%',
        dataSource: expenses,
        xValueMapper: (Expense expense, _) => expense.category,
        yValueMapper: (Expense expense, _) => double.parse(
            (((expense.amount) / totalAmount) * 100).toStringAsFixed(2)),
      )
    ],
    tooltipBehavior: TooltipBehavior(
        format: 'point.x : point.y%',
        enable: true,
        duration: 5000,
        textStyle: GoogleFonts.poppins()),
  );
}
