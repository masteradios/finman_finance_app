class Expense {
  final String category;
  String imageUrl;
  final double amount;
  final String note;
  DateTime dateTime;

  Expense(
      {required this.category,
      this.imageUrl = '',
      required this.dateTime,
      required this.amount,
      this.note = ''});
  factory Expense.fromJson(json) {
    return Expense(
        dateTime: json['dateTime'].toDate(),
        note: json['note'] ?? '',
        imageUrl: json['imageUrl'] ?? '',
        category: json['category'],
        amount: double.parse(json['amount'].toString()));
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'imageUrl': imageUrl,
      'amount': amount,
      'note': note,
      'dateTime': dateTime
    };
  }
}
