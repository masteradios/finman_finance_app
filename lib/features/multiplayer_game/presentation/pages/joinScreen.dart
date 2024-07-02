import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildJoinScreen extends StatelessWidget {
  final VoidCallback callback;
  const BuildJoinScreen({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                callback();
              },
              child: Container(
                width: 100,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xffffa700)),
                child: Text(
                  'Join',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // GestureDetector(
            //   onTap: () {
            //     _addPoints(10);
            //   },
            //   child: Container(
            //     padding: EdgeInsets.all(10),
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(8),
            //         color: Color(0xffffa700)),
            //     child: Text(
            //       'Find Score',
            //       style: GoogleFonts.poppins(
            //           color: Colors.white,
            //           fontSize: 18,
            //           fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
