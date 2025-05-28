// Removed Riverpod import
// import 'package:expense_tracker/models/expense.dart'; // This import seems unused here
import 'package:expense_tracker/models/transaction_demo.dart';
// Removed Riverpod provider import
import 'package:expense_tracker/provider/transactions_provider.dart'; // GetX Controller
// import 'package:expense_tracker/widgets/expenses_list/expense_item.dart'; // This was likely for Expense model
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Added GetX import

// Changed from ConsumerWidget to StatelessWidget
// Removed 'transactions' parameter from constructor as it will now get data from GetX controller
class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    // Find the TransactionsController.
    // It should have been put by a parent widget or higher up in the app.
    final TransactionsController transactionsController = Get.find<TransactionsController>();

    // Use Obx to listen to changes in the transactions list from the controller
    return Obx(() {
      if (transactionsController.transactions.isEmpty) {
        return const Center(
          child: Text("No transactions found. Start adding some!"),
        );
      }
      return ListView.builder(
        itemCount: transactionsController.transactions.length,
        itemBuilder: (ctx, index) {
          final transaction = transactionsController.transactions[index];
          return Dismissible(
            key: ValueKey(transaction.transactionId), // Use a unique key
            background: Container(
              color: Theme.of(context).colorScheme.error.withOpacity(0.75),
              margin: EdgeInsets.symmetric(
                horizontal: Theme.of(context).cardTheme.margin!.horizontal,
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white, size: 40),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              final removedTransaction = transaction;
              final removedTransactionIndex = index;

              transactionsController.removeExpense(removedTransaction.transactionId); // removeExpense is the method name in controller

              ScaffoldMessenger.of(ctx).clearSnackBars();
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 3),
                  content: const Text("Transaction Deleted."),
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () {
                      transactionsController.addExpenseAt(removedTransactionIndex, removedTransaction); // addExpenseAt is method in controller
                    },
                  ),
                ),
              );
            },
            // Using ListTile as in the original for TransactionDemo.
            // Consider creating a TransactionItem widget for better structure if needed.
            child: ListTile(
              title: Text(transaction.merchant.isNotEmpty ? transaction.merchant : "Transaction"), // Display merchant or a default title
              subtitle: Text(transaction.description ?? "No description"), // Display description
              trailing: Text("\$${transaction.amount.toStringAsFixed(2)}"), // Display amount
              // leading: Icon(Icons.monetization_on), // Example icon
            ),
          );
        },
      );
    });
  }
}
