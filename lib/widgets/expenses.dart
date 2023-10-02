import 'package:expense_tracker/provider/expenses_provider.dart';
import 'package:expense_tracker/provider/transactions_provider.dart';
import 'package:expense_tracker/screens/add_new_transaction_screen.dart';
import 'package:expense_tracker/screens/transactions_list.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'expenses_list/expense_list.dart';

class Expenses extends ConsumerWidget {
  const Expenses({super.key});

  void _openAddExpenseOverlay(context) {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return const NewExpense();
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = const Center(
      child: Text("No expenses found. Start adding some!"),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter ExpenseTracker"),
        actions: [
          IconButton(
            // onPressed: () {
            //   Navigator.push(context, MaterialPageRoute(builder: (builder) {
            //     return const AddNewTransactionScreen();
            //   }));
            // },
            onPressed: () => _openAddExpenseOverlay(context),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: ref.watch(expensesProvider)),
                Expanded(
                    child: ref.watch(expensesProvider).isEmpty
                        ? mainContent
                        : TransactionList(
                            transactions: ref.watch(transactionsProvider))
                    // ExpenseList(
                    //     expenses: ref.watch(expensesProvider),
                    //   ),
                    ),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: ref.watch(expensesProvider))),
                Expanded(
                    child: ref.watch(expensesProvider).isEmpty
                        ? mainContent
                        : TransactionList(
                            transactions: ref.watch(transactionsProvider))
                    // ExpenseList(
                    //     expenses: ref.watch(expensesProvider),
                    //   ),
                    ),
              ],
            ),
    );
  }
}
