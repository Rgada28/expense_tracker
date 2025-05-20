import 'package:expense_tracker/provider/expenses_provider.dart'; // GetX Controller
import 'package:expense_tracker/models/expense.dart'; // Expense model
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // GetX import

// Changed from ConsumerStatefulWidget to StatelessWidget
class ExpenseList extends StatelessWidget {
  const ExpenseList({super.key});

  @override
  Widget build(BuildContext context) {
    // Find the ExpensesController. It should have been put by a parent widget (e.g., Expenses widget).
    final ExpensesController expensesController = Get.find<ExpensesController>();

    // Use Obx to listen to changes in the expenses list from the controller
    return Obx(() {
      // If no expenses, show a message
      if (expensesController.expenses.isEmpty) {
        return const Center(
          child: Text("No expenses found. Start adding some!"),
        );
      }

      // Otherwise, display the list of expenses
      return ListView.builder(
        itemCount: expensesController.expenses.length,
        itemBuilder: (ctx, index) {
          final expense = expensesController.expenses[index];
          return Dismissible(
            key: ValueKey(expense.id), // Use a unique key for each item
            background: Container(
              color: Theme.of(context).colorScheme.error.withOpacity(0.75),
              margin: EdgeInsets.symmetric(
                horizontal: Theme.of(context).cardTheme.margin!.horizontal,
              ),
              child: const Icon(Icons.delete, color: Colors.white, size: 40),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              // Store the expense and its index for potential undo
              final removedExpense = expense;
              final removedExpenseIndex = index;
              
              // Remove the expense using the controller
              expensesController.removeExpense(removedExpense.id);

              ScaffoldMessenger.of(ctx).clearSnackBars();
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 3),
                  content: const Text("Expense Deleted."),
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () {
                      // Add the expense back at its original position using the controller
                      expensesController.addExpenseAt(removedExpenseIndex, removedExpense);
                    },
                  ),
                ),
              );
            },
            // Child is now ExpenseItem, assuming it takes an Expense object
            // If ExpenseItem was designed for UTransaction, it will also need refactoring.
            // For now, assuming ExpenseItem can handle an Expense object.
            child: ExpenseItem(expense), 
          );
        },
      );
    });
  }
}
