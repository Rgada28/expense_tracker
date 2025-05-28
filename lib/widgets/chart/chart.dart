import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Added GetX import

import 'package:expense_tracker/widgets/chart/chart_bar.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/provider/expenses_provider.dart'; // Import GetX controller

class Chart extends StatelessWidget {
  // Removed 'required this.expenses' from constructor
  const Chart({super.key});

  // Note: expensesController is accessed inside methods/getters that are called by build method.
  // Alternatively, it could be initialized directly in the build method if preferred.

  List<ExpenseBucket> _getBuckets(ExpensesController controller) {
    return [
      ExpenseBucket.forCategory(controller.expenses, Category.food),
      ExpenseBucket.forCategory(controller.expenses, Category.leisure),
      ExpenseBucket.forCategory(controller.expenses, Category.travel),
      ExpenseBucket.forCategory(controller.expenses, Category.work),
    ];
  }

  double _getMaxTotalExpense(List<ExpenseBucket> currentBuckets) {
    double maxTotalExpense = 0;
    for (final bucket in currentBuckets) {
      if (bucket.totalExpenses > maxTotalExpense) {
        maxTotalExpense = bucket.totalExpenses;
      }
    }
    return maxTotalExpense;
  }

  @override
  Widget build(BuildContext context) {
    final ExpensesController expensesController = Get.find<ExpensesController>();
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    // Wrap the chart UI with Obx to make it reactive
    return Obx(() {
      // Calculate buckets and maxTotalExpense based on current controller state
      final currentBuckets = _getBuckets(expensesController);
      final maxTotal = _getMaxTotalExpense(currentBuckets);

      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 8,
        ),
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.3),
              Theme.of(context).colorScheme.primary.withOpacity(0.0)
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ...currentBuckets.map((bucket) {
                    return ChartBar(
                      fill: bucket.totalExpenses == 0 || maxTotal == 0
                          ? 0
                          : bucket.totalExpenses / maxTotal,
                    );
                  }).toList()
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: currentBuckets
                  .map(
                    (bucket) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          categoryIcons[bucket.category],
                          color: isDarkMode
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.7),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      );
    });
  }
}
