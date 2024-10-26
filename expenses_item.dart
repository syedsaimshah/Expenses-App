import 'package:expenses_app/model/expense.dart';
import 'package:flutter/material.dart';

class ExpensesItem extends StatelessWidget {
  const ExpensesItem({
    super.key,
    required this.expense,
  });

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text('${expense.amount.toStringAsFixed(2)} DH'),
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcon[
                        expense.category]), // Ensure categoryIcon is defined
                    const SizedBox(width: 5),
                    Text(expense.date
                        .toString()), // Ensure formatDate is defined
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
