// Removed: import 'package:expense_tracker/models/transaction.dart'; // No longer using UTransaction
import 'package:flutter/material.dart';

import '../../models/expense.dart'; // Using Expense model

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(
    this.expense, { // Changed parameter name and type
    super.key,
  });

  final Expense expense; // Changed to Expense type

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // If an ExpenseDetailScreen exists and is needed for Expense objects,
        // this navigation logic would need to be updated or re-enabled.
        // For now, keeping it commented as per original.
        // Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
        //   return ExpenseDetailScreen( // This screen would also need to accept Expense
        //     expense: expense,
        //   );
        // }));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                expense.title, // Use expense.title
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text('\$${expense.amount.toStringAsFixed(2)}'), // Use expense.amount
                  const Spacer(),
                  Row(
                    children: [
                      Icon(
                        categoryIcons[expense.category], // Use expense.category
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(expense.formattedDate), // Use expense.formattedDate (from Expense model)
                      // const SizedBox( // This SizedBox seems redundant if formattedDate is the last item
                      //   width: 8,
                      // ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
