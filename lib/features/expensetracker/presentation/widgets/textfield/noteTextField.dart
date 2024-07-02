import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextField buildNoteTextField({required TextEditingController controller}) {
  return TextField(
    controller: controller,
    maxLength: 30,
    cursorColor: Colors.green.shade400,
    decoration: InputDecoration(
      hintText: 'Write a Note...',
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.white)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Colors.white)),
      filled: true,
      fillColor: Colors.white,
    ),
    style: GoogleFonts.poppins(),
  );
}
