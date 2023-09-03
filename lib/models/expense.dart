import 'package:flutter/material.dart';

class Expense {
  final int id;
  final String category;
  final double amount;
  final String title;
  final DateTime dateTime;

  Expense({
    required this.dateTime,
    required this.title,
    required this.id,
    required this.category,
    required this.amount,
  });

  Map<String, dynamic> toMap() => {
        //id will generate automatically
        'title': title,
        'category': category,
        'dateTime': dateTime.toString(),
        'amount': amount.toString(),
      };

  factory Expense.fromString(Map<String, dynamic> value) => Expense(
      dateTime: DateTime.parse(value['dateTime']),
      title: value['title'],
      id: value['id'],
      category: value['category'],
      amount: double.parse(value['amount']));

}
