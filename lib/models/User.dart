import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';

class User {
  int id;
  String name;
  List<Account> accounts;
  List<Category> categories;
  DateTime dob;

  User({
    required this.id,
    required this.name,
    required this.accounts,
    required this.categories,
    required this.dob,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dob': dob.toIso8601String(),
      'accounts': accounts.map((account) => account.toMap()).toList(),
      'categories': categories.map((category) => category.toMap()).toList(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      dob: DateTime.parse(map['dob']),
      accounts: (map['accounts'] as List<dynamic>)
          .map((item) => Account.fromMap(item))
          .toList(),
      categories: (map['categories'] as List<dynamic>)
          .map((item) => Category.fromMap(item))
          .toList(),
    );
  }
}
