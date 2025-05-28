import 'package:get/get.dart';

// Assuming TransactionDemo model is correctly imported from its location
import '../models/transaction_demo.dart';
// Note: The import for '../models/expense.dart' seems unused in the original
// and can be removed if it's not needed by TransactionDemo itself.
// For now, I'll keep it if TransactionDemo might have a relation to Expense,
// but it's a point for potential cleanup.
import '../models/expense.dart';


// Removed: final transactionsProvider = ... (Riverpod specific)

class TransactionsController extends GetxController {
  // Use RxList for observable list of TransactionDemo objects
  var transactions = <TransactionDemo>[].obs;

  TransactionsController() {
    // Initialize with default transactions
    transactions.value = [
      TransactionDemo(1, 99, DateTime.now(), "Cab", 1, 1, 1),
      TransactionDemo(1, 250, DateTime.now(), "Movie", 2, 2, 2)
    ];
  }

  // Method names are kept as in the original provider (e.g., addExpense)
  // but they operate on TransactionDemo objects.
  // Consider renaming for clarity in a future refactoring pass (e.g., addTransactionDemo).

  void addExpense(TransactionDemo transactionDemo) {
    transactions.add(transactionDemo);
  }

  void addExpenseAt(int index, TransactionDemo transactionDemo) {
    transactions.insert(index, transactionDemo);
  }

  void updateExpense(TransactionDemo transactionDemo) {
    final index = transactions.indexWhere((transaction) =>
        transactionDemo.transactionId == transaction.transactionId);

    if (index != -1) {
      transactions[index] = transactionDemo;
    }
  }

  void removeExpense(int transactionId) {
    transactions
        .removeWhere((transaction) => transaction.transactionId == transactionId);
  }

  // Optional: If you need to provide a way to get the raw list (not observable)
  // List<TransactionDemo> get plainTransactions => transactions.toList();
}
