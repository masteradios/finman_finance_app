import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildButton({required String title, required VoidCallback callback}) {
  return GestureDetector(
    onTap: callback,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.green.shade300, borderRadius: BorderRadius.circular(5)),
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
    ),
  );
}
