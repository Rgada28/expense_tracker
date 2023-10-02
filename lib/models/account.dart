import 'package:sqflite/sqflite.dart' as sql;

const String tableAccount = 'account';
const String columnAccountId = 'accountId';
const String columnAccountName = 'accountName';
const String columnAccountBalance = 'accountBalance';
const String columnTransactions = 'transactions';

class Account {
  int id;
  String name;
  int isLending;
  double balance;
  // List<UTransaction> transactions;
  // List<TransactionDemo> transactions;
  Account({
    required this.id,
    required this.name,
    required this.isLending,
    required this.balance,
    // required this.transactions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isLending': isLending,
      'balance': balance,
      // 'transactions':
      //     transactions.map((transaction) => transaction.toMap()).toList(),
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      name: map['name'],
      isLending: map['isLending'],
      balance: map['balance'],
      // transactions: (map['transactions'] as List<dynamic>)
      //     .map((item) => TransactionDemo.fromMap(item))
      //     .toList(),
    );
  }
}

class AccountProvider {
  late sql.Database db;

  Future open(String path) async {
    db =
        await sql.openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''  CREATE TABLE account ( 
               accountId INTEGER PRIMARY KEY, 
               accountName TEXT, 
               accountBalance REAL, 
               
                )''');
    });
  }

  Future<Account> insert(Account account) async {
    account.id = await db.insert("account", account.toMap());
    return account;
  }

  Future<Account?> getAccount(int id) async {
    final List<Map<String, dynamic>> maps = await db.query(tableAccount,
        columns: [
          columnAccountId,
          columnAccountName,
          columnAccountBalance,
          // columnTransactions,
        ],
        where: '$columnAccountId = ?',
        whereArgs: [id]);

    if (maps.isEmpty) {
      return null;
    }

    return Account.fromMap(maps.first);
  }

  Future<int> delete(int id) async {
    return await db
        .delete(tableAccount, where: '$columnAccountId = ?', whereArgs: [id]);
  }

  Future<int> update(Account account) async {
    return await db.update(tableAccount, account.toMap(),
        where: '$columnAccountId = ?', whereArgs: [account.id]);
  }

  Future close() async => db.close();
}
