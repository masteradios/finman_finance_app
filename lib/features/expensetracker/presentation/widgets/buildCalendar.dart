import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<DateTime?> buildCalendar({required BuildContext context}) {
  return showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: DateTime.now(),
      helpText: 'Select Date',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
              primaryColor: Colors.green, // Header background color
              hintColor: Colors.green, // Selected date circle color
              colorScheme: ColorScheme.light(primary: Colors.green),
              buttonTheme: ButtonThemeData(
                textTheme: ButtonTextTheme.primary, // Button text color
              ),
              dialogBackgroundColor: Colors.white,
              textTheme: TextTheme(
                labelLarge: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.bold),
                titleLarge: GoogleFonts.poppins(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),

                bodyLarge: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w800),

                titleSmall: GoogleFonts.poppins(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                headlineLarge: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold), // Year picker headline
                bodyMedium:
                    GoogleFonts.poppins(color: Colors.black, fontSize: 18),
              ),
              inputDecorationTheme: InputDecorationTheme(
                suffixStyle: GoogleFonts.poppins(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                filled: true,
                fillColor: Colors.grey[200], // Text field background color
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide.none,
                ),
                hintStyle: TextStyle(color: Colors.grey),
                labelStyle: TextStyle(color: Colors.black),
              ),
              textSelectionTheme: TextSelectionThemeData(
                  cursorColor: Colors.green,
                  selectionColor: Colors.black,
                  selectionHandleColor: Colors.black)),
          child: child!,
        );
      },
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime.now());
}
