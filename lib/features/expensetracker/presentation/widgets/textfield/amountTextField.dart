import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextFormField buildAmountTextField(
    {required TextEditingController controller}) {
  return TextFormField(
    validator: (val) {
      if (val == '') {
        return "Enter valid amount  ";
      }
      return null;
    },
    controller: controller,
    cursorColor: Colors.green.shade400,
    keyboardType: TextInputType.number,
    textAlignVertical: TextAlignVertical.center,
    style: GoogleFonts.poppins(),
    decoration: InputDecoration(
      fillColor: Colors.white,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: BorderSide(
          color: Colors.white,
          width: 2.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: BorderSide(
          color: Colors.grey,
          width: 2.0,
        ),
      ),
      hintText: 'Enter Amount',
      prefixIcon: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 5,
          ),
          Text(
            'INR',
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            width: 1,
            height: 24,
            color: Colors.grey,
          ),
        ],
      ),
    ),
  );
}
