import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:stocksapp/features/auth/data/models/userModel.dart';
import 'package:stocksapp/features/auth/domain/manager/authProvider.dart';
import 'package:stocksapp/features/learning/data/firestore_method.dart';
import 'package:stocksapp/features/learning/data/models/level.dart';

import '../../data/models/chapter.dart';

class LearningContentDetailsPage extends StatefulWidget {
  final Chapter chapter;
  final int levelNumber;
  const LearningContentDetailsPage(
      {super.key, required this.chapter, required this.levelNumber});

  @override
  State<LearningContentDetailsPage> createState() =>
      _LearningContentDetailsPageState();
}

class _LearningContentDetailsPageState
    extends State<LearningContentDetailsPage> {
  void updateMoney({required double myMoney}) {
    if (widget.chapter.isLast) {
      LearningService().updateData(
          context: context,
          newLevel: widget.levelNumber + 1,
          newChapter: 1,
          myMoney: myMoney);
      _onBasicAlertPressed(context);
    } else {
      LearningService().updateData(
          newLevel: widget.levelNumber,
          newChapter: widget.chapter.chapterNumber + 1,
          context: context,
          myMoney: myMoney);
    }
  }

  _onBasicAlertPressed(context) {
    // Future.delayed(Duration(seconds: 5), () {
    //   Navigator.of(context).pop();
    //   Navigator.of(context).pop(); // Close the dialog
    // });
    Alert(
        style: AlertStyle(
            backgroundColor: Colors.white, overlayColor: Colors.black12),
        context: context,
        content: Column(
          children: [
            Image.asset(
              'assets/congrats.gif',
              width: 190,
              height: 190,
            ),
            Text('You won Rs. 50!!',
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 22))
          ],
        ),
        buttons: [
          DialogButton(
              color: Color(0xffa9dbca),
              child: Text(
                'Hurray!!',
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              })
        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<AuthServiceProvider>(context).userModel;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Column(
                children: [
                  Text(
                    widget.chapter.title,
                    style:
                        GoogleFonts.poppins(color: Colors.black, fontSize: 22),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.zero,
                    child: Text(
                      widget.chapter.content,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ),
                ],
              )),
              ElevatedButton(
                  onPressed:
                      (userModel.currentChapter == widget.chapter.chapterNumber)
                          ? () {
                              updateMoney(myMoney: userModel.myMoney);
                            }
                          : null,
                  child: Text(
                    'I have Read It',
                    style: GoogleFonts.poppins(color: Colors.black),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
