import 'package:animated_floating_widget/widgets/floating_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bullet_list/flutter_bullet_list.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildPage(
    {required String image,
    required String title,
    required List<String> content,
    required VoidCallback onTap,
    bool isLast = false,
    required double scale}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(
        child: Column(
          children: [
            FloatingWidget(
              verticalSpace: 10,
              beginOffset: Offset(2, 3),
              child: Image.asset(
                image,
                scale: scale,
              ),
              duration: Duration(seconds: 2),
              reverseDuration: Duration(seconds: 2),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Container(
                    width: 350,
                    height: 150,
                    child: FlutterBulletList(
                      bulletSpacing: 10,
                      bulletSize: 3,
                      textStyle: GoogleFonts.poppins(fontSize: 13),
                      data: [
                        for (int i = 0; i < content.length; i++)
                          ListItemModel(label: content[i]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      SizedBox(
        height: 100,
      ),
      GestureDetector(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4), color: Colors.green),
            child: Center(
              child: Text(
                (isLast) ? 'Done' : 'Next',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
              ),
            )),
      )
    ],
  );
}
