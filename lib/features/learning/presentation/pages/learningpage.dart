import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocksapp/features/auth/data/models/userModel.dart';
import 'package:stocksapp/features/learning/manager/learningProvider.dart';

import '../../../../constants.dart';
import '../widgets/buildLevelTile.dart';

class LearningPage extends StatefulWidget {
  final UserModel user;
  const LearningPage({super.key, required this.user});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  void isLevelComplete(
      {required int currentLevel, required int currentChapter}) {}

  @override
  Widget build(BuildContext context) {
    LearningProvider learningProvider = Provider.of<LearningProvider>(context);
    List<bool> isVisible = learningProvider.isVisible;
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView.builder(
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  learningProvider.changeVisibility(index);
                },
                child: BuildTile(
                  isVisible: isVisible[index],
                  level: levels[index],
                ));
          },
          itemCount: levels.length,
        ));
  }
}
