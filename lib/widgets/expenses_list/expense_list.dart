import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/provider/expenses_provider.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseList extends ConsumerWidget {
  const ExpenseList({super.key, required this.expenses});

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemBuilder: (context, index) => Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.8),
          margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal),
        ),
        onDismissed: (direction) {
          ref.read(expensesProvider.notifier).removeExpense(expenses[index].id);

          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 3),
            content: const Text("Expense Deleted."),
            action: SnackBarAction(
                label: "undo",
                onPressed: () {
                  ref
                      .read(expensesProvider.notifier)
                      .addExpenseAt(index, expenses[index]);
                }),
          ));
        },
        key: ValueKey(expenses[index]),
        child: ExpenseItem(expenses[index]),
      ),
      itemCount: expenses.length,
    );
  }
}
