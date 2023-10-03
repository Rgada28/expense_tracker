import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';

import '../../models/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(
    this.transaction, {
    super.key,
  });

  final UTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
        //   return ExpenseDetailScreen(
        //     expense: transaction,
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
                transaction.merchant,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text('\$ ${transaction.amount.toStringAsFixed(2)}'),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(
                        categoryIcons[transaction.categoryId],
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(transaction.formattedDate),
                      const SizedBox(
                        width: 8,
                      ),
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
