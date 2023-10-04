import 'package:expense_tracker/database/db_helper.dart';
import 'package:expense_tracker/models/user_transaction.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseList extends ConsumerStatefulWidget {
  const ExpenseList({super.key});
  @override
  ConsumerState<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends ConsumerState<ExpenseList> {
  List<UserTransaction> transactions = [];

  Future<List<UserTransaction>> fetchTransactions() async {
    transactions = await DbHelper.db.getAllTransactions();
    print(transactions.length);
    print(transactions);
    return transactions;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchTransactions(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemBuilder: (ctx, index) => Dismissible(
              background: Container(
                color: Theme.of(context).colorScheme.error.withOpacity(0.8),
                margin: EdgeInsets.symmetric(
                    horizontal: Theme.of(context).cardTheme.margin!.horizontal),
              ),
              onDismissed: (direction) {
                //TODO Remove Expense from Database
                // final expenseToRemove = transactions[index];
                // ref.read(expensesProvider.notifier).removeExpense(expenseToRemove!.transactionId);

                ScaffoldMessenger.of(ctx).clearSnackBars();

                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 3),
                    content: const Text("Expense Deleted."),
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () {
                        // ref
                        //     .read(expensesProvider.notifier)
                        //     .addExpenseAt(index, expenseToRemove);
                      },
                    ),
                  ),
                );
              },
              key: UniqueKey(),
              child: ExpenseItem(transactions[index]),
            ),
            itemCount: transactions.length,
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text("Fetching Data"),
          );
        }
        return const Center(
          child: Text("No Transactions"),
        );
      },
    );
  }
}
