import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildWaitingScreen extends StatelessWidget {
  const BuildWaitingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeCap: StrokeCap.butt,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Waiting for other player',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
              ),
              Container(
                width: 20,
                child: AnimatedTextKit(repeatForever: true, animatedTexts: [
                  TyperAnimatedText('...',
                      speed: Duration(milliseconds: 800),
                      textStyle: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 22))
                ]),
              )
            ],
          ),
        ],
      ),
    );
  }
}
