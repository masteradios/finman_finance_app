import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:stocksapp/features/expensetracker/data/models/expense.dart';
import 'package:stocksapp/features/expensetracker/domain/expenseprovider.dart';
import 'package:stocksapp/features/expensetracker/presentation/pages/addExpenseScreen.dart';

import '../widgets/buildAppBar.dart';
import '../widgets/buildExpenseList.dart';
import '../widgets/buildGraphCard.dart';

class ExpenseTrackerScreen extends StatefulWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  State<ExpenseTrackerScreen> createState() => _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState extends State<ExpenseTrackerScreen> {
  GlobalKey addKey = GlobalKey();
  GlobalKey graphKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<ExpenseProvider>(context, listen: false).getExpenseData();
    startShowCase();
    super.initState();
  }

  startShowCase() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('expense_tutorial_done') == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await prefs.setBool('expense_tutorial_done', true);
        ShowCaseWidget.of(context).startShowCase([addKey, graphKey]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ExpenseProvider expenseProvider = Provider.of<ExpenseProvider>(context);
    List<Expense> aggregatedExpenseList = expenseProvider.aggregatedExpenses;
    double totalAmountSpent = expenseProvider.totalAmountSpent;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Showcase(
        targetShapeBorder: CircleBorder(),
        key: addKey,
        description: 'Add your Expenses',
        child: Tooltip(
          message: 'Add Expense',
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            shape: CircleBorder(),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddExpenseScreen()));
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
      appBar: buildExpenseAppBar(context: context, title: 'Expense Tracker'),
      body: (expenseProvider.isLoading)
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : (aggregatedExpenseList.isEmpty)
              ? Center(
                  child: Text(
                    'Add your expenses',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Showcase(
                      description: 'Graph of your expenses',
                      key: graphKey,
                      child: buildGraphCard(
                          aggregatedExpenseList: aggregatedExpenseList,
                          totalAmountSpent: totalAmountSpent,
                          income: 50000),
                    ),
                    buildExpenseList(expenses: aggregatedExpenseList)
                  ],
                ),
    );
  }
}
