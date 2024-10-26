import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Define Category enum
enum Category { food, transport, entertainment, other }

// Category icon mapping
final Map<Category, IconData> categoryIcon = {
  Category.food: Icons.fastfood,
  Category.transport: Icons.directions_car,
  Category.entertainment: Icons.movie,
  Category.other: Icons.category,
};

// Model class for Expense
class Expense {
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  // Factory method to create Expense from Firestore data
  factory Expense.fromMap(Map<String, dynamic> data) {
    return Expense(
      title: data['title'] ?? 'No Title',
      amount: (data['amount'] as num).toDouble(),
      date: DateTime.parse(data['date'] ?? DateTime.now().toIso8601String()),
      category: categoryFromString(data['category'] ?? 'other'),
    );
  }

  // Convert Category string to enum
  static Category categoryFromString(String categoryString) {
    return Category.values.firstWhere(
      (e) => e.name == categoryString,
      orElse: () => Category.other,
    );
  }
}
