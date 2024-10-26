import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum Category { food, transport, entertainment, other }

// Helper function to convert string to Category
Category categoryFromString(String categoryString) {
  return Category.values.firstWhere(
    (e) => e.name == categoryString,
    orElse: () => Category.other, // Default case
  );
}

class ExpensesListScreen extends StatelessWidget {
  ExpensesListScreen({Key? key}) : super(key: key);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Function to delete an expense from Firestore
  Future<void> _deleteExpense(String docId) async {
    try {
      await firestore.collection('data').doc(docId).delete();
    } catch (e) {
      throw Exception("Failed to delete expense: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expenses List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('data').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading expenses."));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No expenses added yet."));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, i) {
                final doc = snapshot.data!.docs[i];
                final data = doc.data() as Map<String, dynamic>;

                return Card(
                  child: Dismissible(
                    key: ValueKey(doc.id),
                    background: Container(
                      color: Colors.red.withOpacity(0.9),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) async {
                      try {
                        await _deleteExpense(
                            doc.id); // Delete the document from Firestore
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Expense deleted')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Failed to delete expense: $e')),
                        );
                      }
                    },
                    child: ListTile(
                      title: Text(data['title'] ?? 'No title'),
                      subtitle: Text(
                        'Amount: \$${data['amount'] ?? 0}\n'
                        'Date: ${data['date'] ?? 'No date'}\n'
                        'Category: ${categoryFromString(data['category']).name}',
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
