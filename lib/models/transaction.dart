import 'package:sqflite/sqflite.dart' as sql;

const String tableTransaction = 'transaction';
const String columnId = 'transactionId';
const String columnMerchant = 'merchant';
const String columnSubMerchant = 'subMerchant';
const String columnDebit = 'debit';
const String columnAmount = 'amount';
const String columnCashback = 'cashback';
const String columnDate = 'date';
const String columnOwnShare = 'ownShare';
const String columnDescription = 'description';
const String columnCategoryId = 'categoryId';
const String columnAccountId = 'accountId';
const String columnModeOfPayment = 'modeOfPayment';

class UTransaction {
  int transactionId;
  String merchant;
  String? subMerchant;
  // int debit;
  double amount;
  double? cashback;
  DateTime date;
  double? ownShare;
  String? description;
  int categoryId;
  int accountId;
  String modeOfPayment;

  UTransaction({
    required this.transactionId,
    required this.merchant,
    this.subMerchant,
    // required this.debit,
    required this.amount,
    this.cashback,
    required this.date,
    this.ownShare,
    this.description,
    required this.categoryId,
    required this.accountId,
    required this.modeOfPayment,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': transactionId,
      'merchant': merchant,
      // 'debit': debit,
      'amount': amount,
      'cashback': cashback,
      'date': date.toIso8601String(),
      'ownShare': ownShare,
      'description': description,
      'categoryId': categoryId,
      'accountId': accountId,
      'modeOfPayment': modeOfPayment,
    };
  }

  factory UTransaction.fromMap(Map<String, dynamic> map) {
    return UTransaction(
      transactionId: map['id'],
      merchant: map['merchant'],
      // debit: map['debit'],
      amount: map['amount'] as double,
      cashback: map['cashback'] as double,
      date: DateTime.parse(map['date']),
      ownShare: map['ownShare'] as double,
      description: map['description'],
      categoryId: map['categoryId'],
      accountId: map['accountId'],
      modeOfPayment: map['modeOfPayment'],
    );
  }
}

class TransactionProvider {
  late sql.Database db;

  Future open(String path) async {
    db =
        await sql.openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''  CREATE TABLE transactions ( 
               id INTEGER PRIMARY KEY, 
               date TEXT, 
               merchant TEXT, 
               debit INTEGER,  
               modeOfPayment TEXT
               category_id INTEGER,
               account_id INTEGER, 
               amount REAL, 
               cashback REAL,                
               ownShare REAL, 
               description TEXT, 
               FOREIGN KEY (account_id) REFERENCES accounts(account_id)''');
    });
  }

  Future<UTransaction> insert(UTransaction transaction) async {
    transaction.transactionId =
        await db.insert("transaction", transaction.toMap());
    return transaction;
  }

  Future<UTransaction?> getTransaction(int id) async {
    final List<Map<String, dynamic>> maps = await db.query(tableTransaction,
        columns: [
          columnId,
          columnMerchant,
          columnSubMerchant,
          columnDebit,
          columnAmount,
          columnCashback,
          columnDate,
          columnOwnShare,
          columnDescription,
          columnCategoryId,
          columnAccountId,
          columnModeOfPayment,
        ],
        where: '$columnId = ?',
        whereArgs: [id]);

    if (maps.isEmpty) {
      return null;
    }

    return UTransaction.fromMap(maps.first);
  }

  Future<int> delete(int id) async {
    return await db
        .delete(tableTransaction, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(UTransaction transaction) async {
    return await db.update(tableTransaction, transaction.toMap(),
        where: '$columnId = ?', whereArgs: [transaction.transactionId]);
  }

  Future close() async => db.close();
}
