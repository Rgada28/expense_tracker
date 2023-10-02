import 'package:expense_tracker/database/db_helper.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/provider/expenses_provider.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/transaction.dart';

class ExpenseList extends ConsumerStatefulWidget {
  const ExpenseList({super.key, required this.expenses});
  final List<Expense> expenses;
  @override
  ConsumerState<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends ConsumerState<ExpenseList> {

  Future<List<UTransaction>> fetchTransactions()async{

    List<UTransaction> transactions = await DbHelper.db.getAllPersons();
    widget.expenses.clear();
    widget.expenses.addAll(transactions.map((e) => Expense(title: e.merchant, amount: e.amount, date: e.date, category: Category.food)));
    return transactions;
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) => Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.8),
          margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal),
        ),
        onDismissed: (direction) {
          final expenseToRemove = widget.expenses[index];
          ref.read(expensesProvider.notifier).removeExpense(expenseToRemove.id);

          ScaffoldMessenger.of(ctx).clearSnackBars();

          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 3),
              content: const Text("Expense Deleted."),
              action: SnackBarAction(
                label: "Undo",
                onPressed: () {
                  ref
                      .read(expensesProvider.notifier)
                      .addExpenseAt(index, expenseToRemove);
                },
              ),
            ),
          );
        },
        key: UniqueKey(),
        child: ExpenseItem(widget.expenses[index]),
      ),
      itemCount: widget.expenses.length,
    );
  }
}
