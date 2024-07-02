import 'package:provider/provider.dart';
import 'package:stocksapp/features/auth/data/models/userModel.dart';
import 'package:stocksapp/features/auth/domain/manager/authProvider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stocksapp/features/learning/data/models/level.dart';

import '../pages/learningcontentdetailsScreen.dart';

class BuildTile extends StatelessWidget {
  final bool isVisible;
  final Level level;

  const BuildTile({
    super.key,
    required this.isVisible,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<AuthServiceProvider>(context).userModel;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              titleAlignment: ListTileTitleAlignment.titleHeight,
              leading: Text(
                level.levelNumber.toString() + '.',
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: (level.levelNumber <= user.currentLevel)
                        ? Colors.black
                        : Colors.grey),
              ),
              contentPadding: EdgeInsets.zero,
              title: Text(
                level.title,
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: (level.levelNumber <= user.currentLevel)
                        ? Colors.black
                        : Colors.grey),
              ),
              trailing: GestureDetector(
                child: Icon(
                  (isVisible) ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  size: 25,
                ),
              ),
            ),
          ),
          AnimatedSizeAndFade.showHide(
            show: isVisible,
            child: Column(
              children: [
                for (int index = 0; index < level.chapters.length; index++)
                  TimelineTile(
                    endChild: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: () {
                          (level.levelNumber < user.currentLevel)
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                      body: Center(
                                        child:
                                            Text(level.chapters[index].content),
                                      ),
                                    ),
                                  ),
                                )
                              : (level.levelNumber == user.currentLevel
                                  ? (level.chapters[index].chapterNumber <=
                                          user.currentChapter
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LearningContentDetailsPage(
                                              levelNumber: user.currentLevel,
                                              chapter: level.chapters[index],
                                            ),
                                          ),
                                        )
                                      : null)
                                  : null);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              level.chapters[index].title,
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color:
                                      (level.levelNumber <= user.currentLevel)
                                          ? Colors.black
                                          : Colors.grey),
                            ),
                            Text(
                              (user.currentLevel < level.levelNumber)
                                  ? 'Collect 50 Rs.'
                                  : (user.currentLevel == level.levelNumber)
                                      ? (user.currentChapter ==
                                              level.chapters[index]
                                                  .chapterNumber)
                                          ? 'Collect 50 Rs.'
                                          : (level.chapters[index]
                                                      .chapterNumber <
                                                  user.currentChapter)
                                              ? 'Collected 50 Rs.'
                                              : 'Collect 50 Rs.'
                                      : 'Collected 50 Rs.',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: (user.currentLevel < level.levelNumber)
                                    ? Colors.grey
                                    : (user.currentLevel == level.levelNumber)
                                        ? (user.currentChapter ==
                                                level.chapters[index]
                                                    .chapterNumber)
                                            ? Colors.grey
                                            : (level.chapters[index]
                                                        .chapterNumber <
                                                    user.currentChapter)
                                                ? Colors.green
                                                : Colors.grey
                                        : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    alignment: TimelineAlign.start,
                    beforeLineStyle: LineStyle(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                    afterLineStyle: LineStyle(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                    indicatorStyle: IndicatorStyle(
                      width: 40,
                      height: 40,
                      color: Colors.green,
                      // drawGap: true,
                      iconStyle: IconStyle(
                        fontSize: 20,
                        color: (user.currentLevel < level.levelNumber)
                            ? Colors.white
                            : (user.currentLevel == level.levelNumber)
                                ? (user.currentChapter ==
                                        level.chapters[index].chapterNumber)
                                    ? Colors.yellowAccent
                                    : Colors.white
                                : Colors.white,
                        iconData: (user.currentLevel < level.levelNumber)
                            ? Icons.lock
                            : (user.currentLevel == level.levelNumber)
                                ? (user.currentChapter ==
                                        level.chapters[index].chapterNumber)
                                    ? Icons.warning
                                    : (level.chapters[index].chapterNumber <
                                            user.currentChapter)
                                        ? Icons.done
                                        : Icons.lock
                                : Icons.done,
                      ),
                    ),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
