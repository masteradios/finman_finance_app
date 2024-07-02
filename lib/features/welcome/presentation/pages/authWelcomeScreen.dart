import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stocksapp/features/auth/presentation/pages/loginScreen.dart';
import 'package:stocksapp/features/auth/presentation/pages/registerScreen.dart';

import '../widgets/buildButton.dart';

class AuthWelcomeScreen extends StatelessWidget {
  const AuthWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              height: 610,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/welcomepage.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 2.2,
              //left: MediaQuery.of(context).size.width / 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45.0),
                child: Column(
                  children: [
                    Text(
                      'Welcome!',
                      style: GoogleFonts.poppins(
                          fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    buildButton(
                        title: 'Create new Account',
                        callback: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()));
                        }),
                    buildButton(
                        title: 'Login',
                        callback: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
