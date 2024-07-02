import 'package:animate_text/animate_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildExpenseAttribute extends StatefulWidget {
  final String attribute;
  const BuildExpenseAttribute({super.key, required this.attribute});

  @override
  State<BuildExpenseAttribute> createState() => _BuildExpenseAttributeState();
}

class _BuildExpenseAttributeState extends State<BuildExpenseAttribute> {
  @override
  Widget build(BuildContext context) {
    return AnimateText(
      isRepeat: false,
      speed: AnimateTextSpeed.slow,
      'Rs. ' + widget.attribute,
      style: GoogleFonts.poppins(
          fontSize: 20, color: Colors.black, fontWeight: FontWeight.w700),
      type: AnimateTextType.bottomLeftToTopRight,
    );
  }
}

class BuildExpenseText extends StatefulWidget {
  final String title;
  const BuildExpenseText({super.key, required this.title});

  @override
  State<BuildExpenseText> createState() => _BuildExpenseTextState();
}

class _BuildExpenseTextState extends State<BuildExpenseText> {
  @override
  Widget build(BuildContext context) {
    return AnimateText(
      isRepeat: false,
      speed: AnimateTextSpeed.slow,
      widget.title,
      style: GoogleFonts.poppins(
          fontSize: 21, color: Colors.black38, fontWeight: FontWeight.bold),
      type: AnimateTextType.bottomLeftToTopRight,
    );
  }
}
