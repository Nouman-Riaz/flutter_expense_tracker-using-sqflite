import 'package:flutter/material.dart';
import 'package:expense_tracker/constants/icons.dart';

class ExpenseCategory {
  final String title;
  int entries = 0;
  double totalAmount = 0.0;
  final IconData icon;
  ExpenseCategory(
      {required this.title,
      required this.entries,
      required this.icon,
      required this.totalAmount});
  Map<String, dynamic> toMap() => {
        'title': title,
        'entries': entries,
        'totalAmount': totalAmount.toString(),
      };
  factory ExpenseCategory.fromString(Map<String, dynamic> value) =>
      ExpenseCategory(
          title: value['title'],
          entries: value['entries'],
          icon: icons[value['title']] as IconData,
          totalAmount: double.parse(value['totalAmount']));
}
