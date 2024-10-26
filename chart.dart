import 'package:expenses_app/chart/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:expenses_app/model/expense.dart';
import 'package:intl/intl.dart';

class Chart extends StatefulWidget {
  final List<Expense> expenses;

  Chart(this.expenses, {Key? key}) : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Map<String, Object>> get groupedExpenses {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0.0;

      for (var expense in widget.expenses) {
        if (expense.date.day == weekDay.day &&
            expense.date.month == weekDay.month &&
            expense.date.year == weekDay.year) {
          totalSum += expense.amount;
        }
      }

      return {'day': weekDay, 'amount': totalSum};
    });
  }

  double get totalSpending {
    return groupedExpenses.fold(
        0.0, (sum, item) => sum + (item['amount'] as double));
  }

  @override
  Widget build(BuildContext context) {
    print(groupedExpenses); // Debugging output
    return Card(
      elevation: 6,
      child: Row(
        children: groupedExpenses.map((data) {
          final DateTime day = data['day'] as DateTime; // Cast to DateTime
          final double amount = data['amount'] as double; // Cast to double

          return Flexible(
            fit: FlexFit.tight,
            child: ChartBar(
              label: DateFormat.E().format(day),
              spendingAmount: amount,
              spendingPctOfTotal:
                  totalSpending == 0 ? 0.0 : amount / totalSpending,
            ),
          );
        }).toList(),
      ),
    );
  }
}
