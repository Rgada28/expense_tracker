import 'package:sqflite/sqflite.dart' as sql;

// const String tabelTransactionDemo =

class TransactionDemo {
  int transactionId;
  // String merchant;
  // String? subMerchant;
  // int debit;
  double amount;
  // double? cashback;
  DateTime date;
  // double? ownShare;
  String? description;
  int categoryId;
  int accountId;
  int modeOfPaymentId;

  TransactionDemo(this.transactionId, this.amount, this.date, this.description,
      this.categoryId, this.accountId, this.modeOfPaymentId);

  Map<String, dynamic> toMap() {
    return {
      'id': transactionId,
      // 'merchant': merchant,
      // 'debit': debit,
      'amount': amount,
      // 'cashback': cashback,
      'date': date.toIso8601String(),
      // 'ownShare': ownShare,
      'description': description,
      'categoryId': categoryId,
      'accountId': accountId,
      'modeOfPayment': modeOfPaymentId,
    };
  }

  factory TransactionDemo.fromMap(Map<String, dynamic> map) {
    return TransactionDemo(
      map['id'] as int,
      // merchant: map['merchant'],
      // debit: map['debit'],
      map['amount'] as double,
      // cashback: map['cashback'] as double,
      DateTime.parse(map['date']),
      // ownShare: map['ownShare'] as double,
      map['description'],
      map['categoryId'],
      map['accountId'],
      map['modeOfPayment'] as int,
    );
  }
}

class TransactionDemoProvider {
  late sql.Database db;

  Future open(String path) async {
    db =
        await sql.openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''  CREATE TABLE transactions ( 
               transactionId INTEGER PRIMARY KEY, 
               date TEXT, 
               modeOfPayment TEXT
               category_id INTEGER,
               account_id INTEGER, 
               amount REAL, 
               description TEXT, 
               FOREIGN KEY (account_id) REFERENCES accounts(account_id)''');
    });
  }

  Future<TransactionDemo> insert(TransactionDemo transaction) async {
    transaction.transactionId =
        await db.insert("transaction", transaction.toMap());
    return transaction;
  }

  Future<TransactionDemo?> getTransaction(int id) async {
    final List<Map<String, dynamic>> maps = await db.query("transactionId",
        columns: [
          "transactionId ",
          "date",
          "modeOfPayment",
          "category_id",
          "account_id",
          "amount",
          "description",
        ],
        where: 'transactionid = ?',
        whereArgs: [id]);

    if (maps.isEmpty) {
      return null;
    }

    return TransactionDemo.fromMap(maps.first);
  }

  Future<int> delete(int id) async {
    return await db
        .delete("transactionDemo", where: 'transactionId = ?', whereArgs: [id]);
  }

  Future<int> update(TransactionDemo transaction) async {
    return await db.update("transactionDemo", transaction.toMap(),
        where: 'transactionId = ?', whereArgs: [transaction.transactionId]);
  }

  Future close() async => db.close();
}
