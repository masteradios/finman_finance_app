import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildHomeTile(
    {required IconData icon,
    required String title,
    required VoidCallback callback}) {
  return Center(
    child: Container(
      width: 215,
      margin: EdgeInsets.all(2),
      child: ListTile(
        onTap: callback,
        contentPadding: EdgeInsets.all(8),
        titleAlignment: ListTileTitleAlignment.center,
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              color: Colors.redAccent.shade200,
              borderRadius: BorderRadius.circular(6)),
          child: (title == 'Expenses')
              ? Image.asset(
                  'assets/bill.png',
                  height: 20,
                  width: 20,
                )
              : Icon(
                  icon,
                  color: Colors.white,
                  size: 40,
                ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
