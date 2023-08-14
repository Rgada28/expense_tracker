import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/expense.dart';

final expensesProvider =
    StateNotifierProvider<ExpensesNotifier, List<Expense>>((ref) {
  return ExpensesNotifier();
});

class ExpensesNotifier extends StateNotifier<List<Expense>> {
  ExpensesNotifier()
      : super([
          Expense(
              title: "Cab",
              amount: 9.99,
              date: DateTime.now(),
              category: Category.travel),
          Expense(
              title: "Movie",
              amount: 15.49,
              date: DateTime.now(),
              category: Category.leisure)
        ]);

  void addExpense(Expense expense) {
    state = [...state, expense];
  }

  void addExpenseAt(int index, Expense expense) {
    final updatedExpenses = [...state];
    updatedExpenses.insert(index, expense);
    state = updatedExpenses;
  }

  void updateExpense(Expense updatedExpense) {
    final index =
        state.indexWhere((expense) => expense.id == updatedExpense.id);

    if (index != -1) {
      final updatedExpenses = [...state];
      updatedExpenses[index] = updatedExpense;
      state = updatedExpenses;
    }
  }

  void removeExpense(String expenseId) {
    state = state.where((expense) => expense.id != expenseId).toList();
  }
}
