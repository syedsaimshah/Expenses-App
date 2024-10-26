import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_app/chart/chart.dart';
import 'package:expenses_app/model/expense.dart';
import 'package:expenses_app/new_expense.dart';
import 'package:expenses_app/widgets/expenses_list/expenses_list.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();
    _fetchExpenses(); // Fetch expenses on initialization
  }

  // Fetch expenses from Firestore
  Future<void> _fetchExpenses() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('data').get();
      setState(() {
        _expenses = snapshot.docs
            .map((doc) => Expense.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (e) {
      print("Failed to fetch expenses: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size.width;
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses Tracker App", style: TextStyle(fontSize: 19)),
        centerTitle: true,
      ),
      body: mq < 600
          ? Center(
              child: Column(
                children: [
                  Expanded(child: Chart(_expenses)), // Chart updates with _expenses
                  Expanded(
                    child: ExpensesListScreen(),
                  ),
                ],
              ),
            )
          : Row(
              children: [
                Expanded(child: Chart(_expenses)), // Chart updates with _expenses
                Expanded(
                  child: ExpensesListScreen(),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: isDarkMode
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.primary.withOpacity(0.6),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            useSafeArea: true,
            backgroundColor: isDarkMode
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.primaryContainer.withOpacity(1),
            context: context,
            builder: (ctx) => NewExpense((expense) {
              // Callback to refresh expenses after adding a new one
              _fetchExpenses(); 
            }),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
