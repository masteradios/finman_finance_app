import 'package:flutter/material.dart';

import '../../data/models/expense.dart';
import 'buildExpenseTile.dart';

Widget buildExpenseList({required List<Expense> expenses}) {
  return ListView.builder(
    shrinkWrap: true,
    itemBuilder: (context, index) {
      Expense currentExpense = expenses[index];
      return buildExpenseTile(expense: currentExpense, context: context);
    },
    itemCount: expenses.length,
  );
}
