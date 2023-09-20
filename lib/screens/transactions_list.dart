import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/transaction_demo.dart';
import 'package:expense_tracker/provider/expenses_provider.dart';
import 'package:expense_tracker/provider/transactions_provider.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionList extends ConsumerWidget {
  const TransactionList({super.key, required this.transactions});

  final List<TransactionDemo> transactions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemBuilder: (ctx, index) => Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.error.withOpacity(0.8),
          margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal),
        ),
        onDismissed: (direction) {
          final transactionToRemove = transactions[index];
          ref
              .read(transactionsProvider.notifier)
              .removeExpense(transactionToRemove.transactionId);

          ScaffoldMessenger.of(ctx).clearSnackBars();

          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 3),
              content: const Text("Expense Deleted."),
              action: SnackBarAction(
                label: "Undo",
                onPressed: () {
                  ref
                      .read(transactionsProvider.notifier)
                      .addExpenseAt(index, transactionToRemove);
                },
              ),
            ),
          );
        },
        key: UniqueKey(),
        child: ListTile(trailing: Text("${transactions[index].amount}")),
      ),
      itemCount: transactions.length,
    );
  }
}
