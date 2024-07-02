
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stocksapp/features/expensetracker/data/expenseCategories.dart';
import 'package:stocksapp/features/expensetracker/domain/expenseprovider.dart';
import 'package:stocksapp/features/expensetracker/presentation/widgets/buildAppBar.dart';

import '../../data/models/expense.dart';
import '../widgets/buildCalendar.dart';
import '../widgets/textfield/amountTextField.dart';
import '../widgets/textfield/noteTextField.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    _amountController.dispose();
    super.dispose();
  }

  void onTapCalendarIcon() async {
    final pickedDate = await buildCalendar(context: context);
    if (pickedDate != null) {
      Provider.of<ExpenseProvider>(context, listen: false).pickDate(pickedDate);
      Provider.of<ExpenseProvider>(context, listen: false).formatDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    ExpenseProvider expenseProvider = Provider.of<ExpenseProvider>(context);
    return Scaffold(
      appBar: buildExpenseAppBar(context: context, title: 'Add a payment'),
      body: (expenseProvider.isLoading)
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildAmountTextField(controller: _amountController),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        'Select Category',
                        style: GoogleFonts.poppins(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    buildCategoryList(context: context),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        children: [
                          Text(
                            'Write a Note ',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          Text(
                            '(optional)',
                            style: GoogleFonts.poppins(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    buildNoteTextField(controller: _noteController),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Select Date',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ListTile(
                        title: (expenseProvider.pickedDate == null)
                            ? null
                            : Text(expenseProvider.formattedDate),
                        trailing: GestureDetector(
                          onTap: onTapCalendarIcon,
                          child: Icon(Icons.date_range),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Row(
                        children: [
                          Text(
                            'Upload file',
                            style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                          Text(
                            ' (optional)',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ListTile(
                        onTap: () {
                          expenseProvider.getImage();
                        },
                        leading: Icon(Icons.upload_file_rounded),
                        title: (expenseProvider.image != null)
                            ? Text(expenseProvider.image!.name)
                            : Row(
                                children: [
                                  Text(
                                    'Choose a file to upload ',
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    '(JPG,PNG)',
                                    style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_amountController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Enter valid amount')));
                          } else if (expenseProvider.pickedDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Invalid Date')));
                          } else {
                            Expense expense = Expense(
                                note: _noteController.text.trim(),
                                category: expenseCategories[
                                    expenseProvider.currentCategory],
                                amount:
                                    double.parse(_amountController.text.trim()),
                                dateTime: expenseProvider.pickedDate!);
                            expenseProvider.uploadExpenseDetails(
                                context: context, expense: expense);
                          }
                        },
                        child: Text(
                          'Upload',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green, elevation: 5),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

Widget buildCategoryList({required BuildContext context}) {
  ExpenseProvider expenseProvider = Provider.of<ExpenseProvider>(context);
  return Container(
    margin: EdgeInsets.only(top: 2),
    height: 40,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          expenseProvider.selectCategory(newCategoryIndex: index);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          padding: EdgeInsets.all(5),
          width: 110,
          height: 20,
          child: Center(
              child: Text(
            expenseCategories[index],
            style: GoogleFonts.poppins(fontSize: 12),
          )),
          decoration: BoxDecoration(
              border: Border.all(
                  width: 2,
                  color: (index == expenseProvider.currentCategory)
                      ? Colors.black
                      : Colors.white),
              borderRadius: BorderRadius.circular(50),
              color: Colors.white),
        ),
      ),
      itemCount: expenseCategories.length,
    ),
  );
}
