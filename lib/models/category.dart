import 'package:sqflite/sqflite.dart' as sql;

const String tableCategory = 'category';
const String columnCategoryId = 'categoryId';
const String columnCategoryName = 'categoryName';
const String columnAmount = 'amount';
const String columnIsExpense = 'isExpense';
const String columnUserId = 'userId';

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

class CategoryProvider {
  late sql.Database db;

  Future open(String path) async {
    db =
        await sql.openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''  CREATE TABLE categories ( 
               categoryId INTEGER PRIMARY KEY, 
               categoryName TEXT, 
               amount REAL, 
               isExpense BOOLEAN, 
               userId INTEGER )''');
    });
  }

  Future<Category> insert(Category category) async {
    category.categoryId = await db.insert("category", category.toMap());
    return category;
  }

  Future<Category?> getCategory(int id) async {
    final List<Map<String, dynamic>> maps = await db.query(tableCategory,
        columns: [
          columnCategoryId,
          columnCategoryName,
          columnAmount,
          columnIsExpense,
          columnUserId,
        ],
        where: '$columnCategoryId = ?',
        whereArgs: [id]);

    if (maps.isEmpty) {
      return null;
    }

    return Category.fromMap(maps.first);
  }

  Future<int> delete(int id) async {
    return await db
        .delete(tableCategory, where: '$columnCategoryId = ?', whereArgs: [id]);
  }

  Future<int> update(Category category) async {
    return await db.update(tableCategory, category.toMap(),
        where: '$columnCategoryId = ?', whereArgs: [category.categoryId]);
  }

  Future close() async => db.close();
}
