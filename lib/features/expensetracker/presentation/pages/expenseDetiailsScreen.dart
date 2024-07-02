import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/models/expense.dart';
import '../../domain/expenseprovider.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  final String category;
  const ExpenseDetailsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    List<Expense> categoryExpense =
        Provider.of<ExpenseProvider>(context).categoryExpenses;
    return Scaffold(
      body: ListView.builder(
          itemCount: categoryExpense.length,
          itemBuilder: (context, index) {
            return Text(categoryExpense[index].category +
                ' : ' +
                categoryExpense[index].amount.toString());
          }),
    );
  }
}

class ExpenseDetails extends StatelessWidget {
  const ExpenseDetails({super.key});

  String formatDate({required DateTime date}) {
    String _formattedDate = '';
    DateFormat formatter = DateFormat.yMMMMd('en_US');
    _formattedDate = formatter.format(date);
    return _formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    List<Expense> categoryExpense =
        Provider.of<ExpenseProvider>(context).categoryExpenses;
    ExpenseProvider expenseProvider = Provider.of<ExpenseProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DataTable2(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            headingTextStyle: GoogleFonts.poppins(
                fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
            dataRowColor:
                WidgetStateColor.resolveWith((states) => Colors.white),
            dataTextStyle:
                GoogleFonts.poppins(fontSize: 12, color: Colors.black),
            columnSpacing: 10,
            horizontalMargin: 5,
            columns: [
              DataColumn2(
                label: Text('Date'),
                size: ColumnSize.S,
              ),
              DataColumn2(
                size: ColumnSize.L,
                label: Text('Category'),
              ),
              DataColumn2(
                  label: Text('Amount'), numeric: true, size: ColumnSize.S),
              DataColumn2(label: Text('Note'), size: ColumnSize.S),
            ],
            rows: List<DataRow>.generate(
                categoryExpense.length,
                (index) => DataRow(cells: [
                      DataCell(
                        Text(
                          formatDate(date: categoryExpense[index].dateTime),
                        ),
                      ),
                      DataCell(
                        Text(categoryExpense[index].category),
                      ),
                      DataCell(
                        Text(
                          categoryExpense[index].amount.toString(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      DataCell(
                        Text(
                          (categoryExpense[index].note.isEmpty)
                              ? '-'
                              : categoryExpense[index].note,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ])),
          ),
        ),
      ),
    );
  }
}
