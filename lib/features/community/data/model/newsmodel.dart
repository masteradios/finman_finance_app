class NewsModel {
  final String title;
  final String link;
  final String published_time;
  final String summary;

  NewsModel(
      {required this.title,
      required this.link,
      required this.published_time,
      required this.summary});

  factory NewsModel.fromJson(json) {
    return NewsModel(
        title: json['title'],
        link: json['link'],
        published_time: json['published_time'],
        summary: json['summary']);
  }
}
