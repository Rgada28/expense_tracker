
import 'package:intl/intl.dart';

DateFormat formatter = DateFormat.yMd();


class UTransaction {
  int? transactionId;
  String merchant;
  String? subMerchant;
  int debit;
  double amount;
  double? cashback;
  DateTime date;
  double? ownShare;
  String? description;
  int categoryId;
  int accountId;
  String modeOfPayment;

  String get formattedDate {
    return formatter.format(date);
  }

  UTransaction({
    this.transactionId,
    required this.merchant,
    this.subMerchant,
    required this.debit,
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
      'amount': amount,
      // 'cashback': cashback,
      'debit':debit,
      'date': date.toIso8601String(),
      // 'ownShare': ownShare,
      // 'description': description,
      'category_id': categoryId,
      'account_id': accountId,
      'mode_of_payment': modeOfPayment,
    };
  }

  @override
  String toString() {
    return 'UTransaction{transactionId: $transactionId, merchant: $merchant, subMerchant: $subMerchant, debit: $debit, amount: $amount, cashback: $cashback, date: $date, ownShare: $ownShare, description: $description, categoryId: $categoryId, accountId: $accountId, modeOfPayment: $modeOfPayment}';
  }

  factory UTransaction.fromMap(Map<String, dynamic> map) {
    return UTransaction(
      transactionId: map['id'],
      merchant: map['merchant'],
      debit: map['debit'],
      amount: map['amount'] as double,
      // cashback: map['cashback'] as double,
      date: DateTime.parse(map['date']),
      // ownShare: map['ownShare'] as double,
      // description: map['description'],
      categoryId: map['category_id'],
      accountId: map['account_id'],
      modeOfPayment: map['mode_of_payment'],
    );
  }
}

// class TransactionProvider {
//   late sql.Database db;
//
//   Future open(String path) async {
//     db =
//         await sql.openDatabase(path, version: 1, onCreate: (db, version) async {
//       await db.execute('''  CREATE TABLE transactions (
//                id INTEGER PRIMARY KEY,
//                date TEXT,
//                merchant TEXT,
//                debit INTEGER,
//                modeOfPayment TEXT
//                category_id INTEGER,
//                account_id INTEGER,
//                amount REAL,
//                cashback REAL,
//                ownShare REAL,
//                description TEXT,
//                FOREIGN KEY (account_id) REFERENCES accounts(account_id)''');
//     });
//   }
//
//   Future<UTransaction> insert(UTransaction transaction) async {
//     transaction.transactionId =
//         await db.insert("transaction", transaction.toMap());
//     return transaction;
//   }
//
//   Future<UTransaction?> getTransaction(int id) async {
//     final List<Map<String, dynamic>> maps = await db.query(tableTransaction,
//         columns: [
//           columnId,
//           columnMerchant,
//           columnSubMerchant,
//           columnDebit,
//           columnAmount,
//           columnCashback,
//           columnDate,
//           columnOwnShare,
//           columnDescription,
//           columnCategoryId,
//           columnAccountId,
//           columnModeOfPayment,
//         ],
//         where: '$columnId = ?',
//         whereArgs: [id]);
//
//     if (maps.isEmpty) {
//       return null;
//     }
//
//     return UTransaction.fromMap(maps.first);
//   }
//
//   Future<int> delete(int id) async {
//     return await db
//         .delete(tableTransaction, where: '$columnId = ?', whereArgs: [id]);
//   }
//
//   Future<int> update(UTransaction transaction) async {
//     return await db.update(tableTransaction, transaction.toMap(),
//         where: '$columnId = ?', whereArgs: [transaction.transactionId]);
//   }
//
//   Future close() async => db.close();
// }
