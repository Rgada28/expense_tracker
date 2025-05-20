// Riverpod import removed
import 'package:expense_tracker/provider/expenses_provider.dart'; // Will be GetX controller
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Added GetX import

// Changed from ConsumerWidget to StatelessWidget
class Expenses extends StatelessWidget {
  const Expenses({super.key});

  void _openAddExpenseOverlay(BuildContext context) { // context is passed for showModalBottomSheet
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return NewExpense(); // NewExpense will also be refactored for GetX
        });
  }

  @override
  Widget build(BuildContext context) {
    // Initialize/Find ExpensesController
    // Using Get.put() here assuming Expenses widget is a primary point for this controller.
    // If initialized higher up in the widget tree (e.g., main.dart), Get.find() would be used.
    final ExpensesController expensesController = Get.put(ExpensesController());

    final width = MediaQuery.of(context).size.width;
    
    // mainContent is not currently used directly with Obx as ExpenseList handles its empty state.
    // Widget mainContent = const Center(
    //   child: Text("No expenses found. Start adding some!"),
    // );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter ExpenseTracker"),
        actions: [
          IconButton(
            onPressed: () => _openAddExpenseOverlay(context), // context is available from build method
            icon: const Icon(Icons.add),
          )
        ],
      ),
      // The body will react to changes in expenses list via Obx in child widgets (Chart, ExpenseList)
      // or by passing RxList and letting children handle reactivity.
      body: width < 600
          ? Column(
              children: [
                // Chart now receives the RxList. Chart widget itself will need to handle it.
                Chart(expenses: expensesController.expenses), 
                const Expanded(
                  // ExpenseList will be refactored to use ExpensesController
                  child: ExpenseList(),
                ),
              ],
            )
          : Row(
              children: [
                // Chart now receives the RxList. Chart widget itself will need to handle it.
                Expanded(child: Chart(expenses: expensesController.expenses)),
                const Expanded(
                  // ExpenseList will be refactored to use ExpensesController
                  child: ExpenseList(),
                ),
              ],
            ),
    );
  }
}
