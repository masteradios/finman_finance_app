import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stocksapp/features/welcome/presentation/pages/onboardingScreen.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/logo.png',
              scale: 2.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'FINMAN : ',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w800, fontSize: 17),
                ),
                Text(
                  'your one-stop solution for finances',
                  style: GoogleFonts.poppins(fontSize: 15),
                )
              ],
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  )),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OnBoardingScreen()));
              },
              child: Text(
                'Explore!!',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
              ))
        ],
      ),
    );
  }
}
