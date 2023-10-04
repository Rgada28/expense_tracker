class Category {
  int categoryId;
  String categoryName;
  double amount;
  bool isExpense;
  int userId;

  Category.withoutId(
      {required this.categoryId,
      required this.categoryName,
      required this.amount,
      required this.isExpense,
      required this.userId});

  Category(this.categoryId, this.categoryName, this.amount, this.isExpense,
      this.userId);

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'amount': amount,
      'isExpense': isExpense,
      'userId': userId,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      int.parse(map['categoryId']),
      map['categoryName'],
      double.parse(map['amount']),
      int.parse(map['isExpense']) == 1 ? true : false,
      int.parse(map['userId']),
    );
  }
}
