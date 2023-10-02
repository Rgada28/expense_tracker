import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:sqflite/sqflite.dart' as sql;

import 'merchant.dart';

const String tableUser = 'user';
const String columnUserId = 'userId';
const String columnUserName = 'userName';
const String columnAccounts = 'accounts';
const String columnCategories = 'categories';
const String columnDob = 'dob';

class User {
  int id;
  String name;
  List<Account> accounts;
  List<Category> categories;
  // List<Merchant> merchants;
  // List<Merchant> subMerchants;
  DateTime dob;

  User({
    required this.id,
    required this.name,
    required this.accounts,
    required this.categories,
    // required this.merchants,
    // required this.subMerchants,
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
      // merchants: (map['merchants'] as List<dynamic>)
      // .map((item) => Merchant.fromMap(item))
      // .toList(),
    );
  }
}

class UserProvider {
  late sql.Database db;

  Future open(String path) async {
    db =
        await sql.openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''  CREATE TABLE users ( 
               userId INTEGER PRIMARY KEY, 
               userName TEXT, 
               accounts TEXT, 
               categories TEXT, 
               dob TEXT )''');
    });
  }

  Future<User> insert(User user) async {
    user.id = await db.insert("user", user.toMap());
    return user;
  }

  Future<User?> getUser(int id) async {
    final List<Map<String, dynamic>> maps = await db.query(tableUser,
        columns: [
          columnUserId,
          columnUserName,
          columnAccounts,
          columnCategories,
          columnDob,
        ],
        where: '$columnUserId = ?',
        whereArgs: [id]);

    if (maps.isEmpty) {
      return null;
    }

    return User.fromMap(maps.first);
  }

  Future<int> delete(int id) async {
    return await db
        .delete(tableUser, where: '$columnUserId = ?', whereArgs: [id]);
  }

  Future<int> update(User user) async {
    return await db.update(tableUser, user.toMap(),
        where: '$columnUserId = ?', whereArgs: [user.id]);
  }

  Future close() async => db.close();
}
