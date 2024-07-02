import 'package:flutter/material.dart';

import '../../data/models/expense.dart';
import 'buildDoughnutChart.dart';
import 'buildExpenseText.dart';

Widget buildGraphCard(
    {required List<Expense> aggregatedExpenseList,
    required double totalAmountSpent,
    required double income}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildExpenseText(title: 'Your Income'),
                //buildExpenseText(),
                BuildExpenseAttribute(attribute: income.toString()),
                BuildExpenseText(title: 'Your Expenses'),
                BuildExpenseAttribute(attribute: totalAmountSpent.toString()),
                BuildExpenseText(title: 'Your Savings'),
                BuildExpenseAttribute(
                    attribute: (income - totalAmountSpent).toString())
              ],
            ),
            Expanded(
              child: buildDoughnutChart(
                  expenses: aggregatedExpenseList,
                  totalAmount: totalAmountSpent),
            )
          ],
        ),
      ),
    ),
  );
}
