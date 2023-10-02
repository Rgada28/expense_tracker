import 'dart:async';

import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static FutureOr<Database?> getDataBase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(path.join(dbPath, 'expense_tracker.db'),
        version: 1, onCreate: (db, version) {
      // db.execute('CREATE TABLE users ('
      //     'id INTEGER PRIMARY KEY AUTOINCREMENT,'
      //     'username VARCHAR(255) NOT NULL,'
      //     'email VARCHAR(255) NOT NULL,'
      //     'password VARCHAR(255) NOT NULL,'
      //     'authorities TEXT)');

      // db.execute('CREATE TABLE accounts ('
      //     'id INTEGER PRIMARY KEY AUTOINCREMENT,'
      //     "account_name TEXT NOT NULL,"
      //     'account_number TEXT NOT NULL,'
      //     'balance REAL NOT NULL,'
      //     'credit_limit REAL,)');
      // // 'user_id INTEGER,'
      // // 'FOREIGN KEY (user_id) REFERENCES users(id))');
      //
      // db.execute('CREATE TABLE categories ('
      //     'id INTEGER PRIMARY KEY AUTOINCREMENT,'
      //     'category_name VARCHAR(255) NOT NULL,'
      //     'amount REAL,'
      //     'is_expense BOOLEAN,'
      //     'user_id INTEGER,'
      //     'FOREIGN KEY (user_id) REFERENCES users(id)');
      //
      // db.execute('CREATE TABLE sub_categories ('
      //     'id INTEGER PRIMARY KEY AUTOINCREMENT,'
      //     'category_name VARCHAR(255) NOT NULL,'
      //     'parent_category_id INTEGER,'
      //     'FOREIGN KEY (parent_category_id) REFERENCES categories(id))');

      return db;
    });
  }
}
