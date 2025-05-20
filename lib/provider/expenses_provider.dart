import 'package:get/get.dart';

import '../models/expense.dart'; // Assuming Expense and Category models are in here

// Removed: final expensesProvider = ... (Riverpod specific)

class ExpensesController extends GetxController {
  // Use RxList for observable list
  var expenses = <Expense>[].obs;

  ExpensesController() {
    // Initialize with default expenses
    expenses.value = [
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
    ];
  }

  void addExpense(Expense expense) {
    expenses.add(expense);
  }

  void addExpenseAt(int index, Expense expense) {
    // RxList handles observable changes automatically
    expenses.insert(index, expense);
  }

  void updateExpense(Expense updatedExpense) {
    final index =
        expenses.indexWhere((expense) => expense.id == updatedExpense.id);

    if (index != -1) {
      // RxList handles observable changes automatically
      expenses[index] = updatedExpense;
    }
  }

  void removeExpense(String expenseId) {
    // RxList handles observable changes automatically
    expenses.removeWhere((expense) => expense.id == expenseId);
  }

  // Optional: If you need to provide a way to get the raw list (not observable)
  // List<Expense> get plainExpenses => expenses.toList();
}
