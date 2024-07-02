import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../data/models/expense.dart';
import '../../domain/expenseprovider.dart';
import '../pages/expenseDetiailsScreen.dart';

Widget buildExpenseTile(
    {required Expense expense, required BuildContext context}) {
  return Container(
    margin: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
    ),
    child: ListTile(
      onTap: () {
        Provider.of<ExpenseProvider>(context, listen: false)
            .getParticularExpenseCategory(category: expense.category);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          // return ExpenseDetailsScreen(
          //   category: expense.category,
          // );

          return ExpenseDetails();
        }));
      },
      trailing: Text(
        'Rs. ' + expense.amount.toString(),
        style: GoogleFonts.poppins(fontSize: 18),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      title: Text(
        expense.category,
        style: GoogleFonts.poppins(fontSize: 18),
      ),
    ),
  );
}
