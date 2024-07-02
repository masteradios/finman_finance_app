import 'chapter.dart';

class Level {
  final int levelNumber;
  final String title;
  final List<Chapter> chapters;

  Level(
      {required this.levelNumber, required this.title, required this.chapters});
}
