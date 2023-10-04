import 'package:intl/intl.dart';

DateFormat formatter = DateFormat.yMd();

class UserTransaction {
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

  UserTransaction({
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
      'debit': debit,
      'date': date.toIso8601String(),
      'category_id': categoryId,
      'account_id': accountId,
      'mode_of_payment': modeOfPayment,
    };
  }

  @override
  String toString() {
    return 'UTransaction{transactionId: $transactionId, merchant: $merchant, subMerchant: $subMerchant, debit: $debit, amount: $amount, cashback: $cashback, date: $date, ownShare: $ownShare, description: $description, categoryId: $categoryId, accountId: $accountId, modeOfPayment: $modeOfPayment}';
  }

  factory UserTransaction.fromMap(Map<String, dynamic> map) {
    return UserTransaction(
      transactionId: map['id'],
      merchant: map['merchant'],
      debit: map['debit'],
      amount: map['amount'] as double,
      date: DateTime.parse(map['date']),
      categoryId: map['category_id'],
      accountId: map['account_id'],
      modeOfPayment: map['mode_of_payment'],
    );
  }
}
