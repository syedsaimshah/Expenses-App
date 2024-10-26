import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_app/model/expense.dart'; // Import the shared Category and Expense classes
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewExpense extends StatefulWidget {
  final void Function(Expense) onAddExpense;

  NewExpense(this.onAddExpense, {super.key});

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? selectedDate;
  final formatter = DateFormat.yMd();
  Category selectedCategory = Category.food;
  final dataCollection = FirebaseFirestore.instance.collection('data');

  Future<void> addData(
    String title,
    double amount,
    DateTime date,
    Category category,
  ) async {
    try {
      await dataCollection.add({
        'title': title,
        'amount': amount,
        'date': date.toIso8601String(),
        'category': category.name,
      });
      // Optionally, call widget.onAddExpense here if needed to update local state
    } catch (e) {
      print('Error adding document: $e');
      // Optionally show a dialog to inform the user about the error.
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return SizedBox(
      height: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              maxLength: 50,
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                labelStyle: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    maxLength: 50,
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: "Amount",
                      labelStyle: TextStyle(fontSize: 15, color: Colors.black),
                      prefixText: '\$',
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        selectedDate == null
                            ? "No date selected"
                            : formatter.format(selectedDate!),
                      ),
                      IconButton(
                        onPressed: () async {
                          final now = DateTime.now();
                          final firstDate =
                              DateTime(now.year - 1, now.month, now.day);
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: now,
                            firstDate: firstDate,
                            lastDate: now,
                          );
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        },
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            DropdownButton<Category>(
              dropdownColor: isDarkMode
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.8),
              items: Category.values
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name),
                      ))
                  .toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              value: selectedCategory,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final enteredAmount =
                        double.tryParse(_amountController.text);
                    final bool amountIsInvalid =
                        enteredAmount == null || enteredAmount <= 0;
                    if (_titleController.text.trim().isEmpty ||
                        amountIsInvalid ||
                        selectedDate == null) {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: const Text("Invalid input"),
                            content: const Text(
                                "Please make sure you entered all fields!"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                },
                                child: const Text("Okay"),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      final newExpense = Expense(
                        title: _titleController.text,
                        amount: enteredAmount,
                        date: selectedDate!,
                        category: selectedCategory,
                      );

                      await addData(
                        newExpense.title,
                        newExpense.amount,
                        newExpense.date,
                        newExpense.category,
                      );

                      widget.onAddExpense(newExpense); // Update local list

                      // Clear inputs after adding
                      _titleController.clear();
                      _amountController.clear();
                      setState(() {
                        selectedDate = null;
                        selectedCategory = Category.food; // Reset to default
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save Expense"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
