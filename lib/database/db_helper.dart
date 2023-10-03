import 'dart:async';

import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();

  static final DbHelper db = DbHelper._();
  late Database _database;

  Future<Database> get database async {
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    final databasePath = await getDatabasesPath();
    String dbpath = path.join(databasePath, "expense.db");
    return await openDatabase(dbpath, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE accounts (
            id INTEGER PRIMARY KEY AUTOINCREMENT ,
            name TEXT NOT NULL,
            isLending INTEGER NOT NULL,
            balance REAL
          )
          ''');

      await db.execute('''  CREATE TABLE user_transactions ( 
               id INTEGER PRIMARY KEY, 
               date TEXT, 
               merchant TEXT, 
               debit INTEGER,  
               mode_of_payment TEXT,
               category_id INTEGER,
               account_id INTEGER, 
               amount REAL,               
               FOREIGN KEY (account_id) REFERENCES accounts(account_id))''');
    });
  }

  Future<List<UTransaction>> getAllTransactions() async {
    final db = await database;
    var response = await db.query("user_transactions");
    List<UTransaction> list =
        response.map((c) => UTransaction.fromMap(c)).toList();
    return list;
  }

  Future<List<Account>> getAllAccounts() async {
    final db = await database;
    var response = await db.query("accounts");
    List<Account> list =
    response.map((c) => Account.fromMap(c)).toList();
    return list;
  }

  addAccountToDatabase(Account account) async {
    final db = await database;
    var raw = await db.insert(
      "accounts",
      account.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  addTransactionToDatabase(UTransaction transaction) async {
    final db = await database;
    var raw = await db.insert(
      "user_transactions",
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  //
  // updatePerson(Person person) async {
  //   final db = await database;
  //   var response = await db.update("Person", person.toMap(),
  //       where: "id = ?", whereArgs: [person.id]);
  //   return response;
  // }
  //
  // Future<Person> getPersonWithId(int id) async {
  //   final db = await database;
  //   var response = await db.query("Person", where: "id = ?", whereArgs: [id]);
  //   return response.isNotEmpty ? Person.fromMap(response.first) : null;
  // }
  //
  // Future<List<Person>> getAllPersons() async {
  //   final db = await database;
  //   var response = await db.query("Person");
  //   List<Person> list = response.map((c) => Person.fromMap(c)).toList();
  //   return list;
  // }
  //
  // deletePersonWithId(int id) async {
  //   final db = await database;
  //   return db.delete("Person", where: "id = ?", whereArgs: [id]);
  // }
  //
  // deleteAllPersons() async {
  //   final db = await database;
  //   db.delete("Person");
  // }
}
