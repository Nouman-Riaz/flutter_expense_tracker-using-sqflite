import 'package:expense_tracker/widgets/total_expenses_fetcher.dart';
import 'package:flutter/material.dart';

class TotalExpenses extends StatefulWidget {
  const TotalExpenses({super.key});
  static const name = '/all_expenses';

  @override
  State<TotalExpenses> createState() => _TotalExpensesState();
}

class _TotalExpensesState extends State<TotalExpenses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Expenses')),
      body: const TotalExpensesFetcher(),
    );
  }
}