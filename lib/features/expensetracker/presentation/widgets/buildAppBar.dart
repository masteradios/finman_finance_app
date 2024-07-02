import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar buildExpenseAppBar(
    {required BuildContext context, required String title}) {
  return AppBar(
    title: Text(
      title,
      style:
          GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white),
    ),
    backgroundColor: Colors.transparent,
    automaticallyImplyLeading: false,
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back_ios_new),
      color: Colors.white,
    ),
  );
}
