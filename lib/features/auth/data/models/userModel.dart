class UserModel {
  String uid;
  final String name;
  final String email;
  final DateTime dob;
  double myMoney;
  int currentChapter;
  int currentLevel;

  UserModel(
      {required this.uid,
      required this.name,
      this.myMoney = 0.0,
      this.currentLevel = 1,
      this.currentChapter = 1,
      required this.email,
      required this.dob});

  factory UserModel.fromJson(json) {
    return UserModel(
        myMoney: double.parse(
            double.parse(json['myMoney'].toString()).toStringAsFixed(2)),
        uid: json['uid'],
        currentLevel: json['currentLevel'],
        currentChapter: json['currentChapter'],
        name: json['name'],
        email: json['email'],
        dob: json['dob'].toDate());
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'dob': dob,
      'currentLevel': currentLevel,
      'currentChapter': currentChapter,
      'myMoney': myMoney
    };
  }
}
