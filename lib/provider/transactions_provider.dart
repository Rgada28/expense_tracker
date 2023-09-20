import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/expense.dart';
import '../models/transaction_demo.dart';

final transactionsProvider =
    StateNotifierProvider<TransactionDemoNotifier, List<TransactionDemo>>(
        (ref) {
  return TransactionDemoNotifier();
});

class TransactionDemoNotifier extends StateNotifier<List<TransactionDemo>> {
  TransactionDemoNotifier()
      : super([
          TransactionDemo(1, 99, DateTime.now(), "Cab", 1, 1, 1),
          TransactionDemo(1, 250, DateTime.now(), "Movie", 2, 2, 2)
        ]);

  void addExpense(TransactionDemo transactionDemo) {
    state = [...state, transactionDemo];
  }

  void addExpenseAt(int index, TransactionDemo transactionDemo) {
    final updatedExpenses = [...state];
    updatedExpenses.insert(index, transactionDemo);
    state = updatedExpenses;
  }

  void updateExpense(TransactionDemo transactionDemo) {
    final index = state.indexWhere((transaction) =>
        transactionDemo.transactionId == transaction.transactionId);

    if (index != -1) {
      final updatedtransactions = [...state];
      updatedtransactions[index] = transactionDemo;
      state = updatedtransactions;
    }
  }

  void removeExpense(int transactionId) {
    state = state
        .where((transaction) => transaction.transactionId != transactionId)
        .toList();
  }
}
