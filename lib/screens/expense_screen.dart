import 'package:expense_tracker/widgets/expense_form.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/expense_fetcher.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});
  static const name = '/expense_screen'; // for routes
  @override
  Widget build(BuildContext context) {
    final category = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense'),
      ),
      body: ExpenseFetcher(category),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => const ExpenseForm(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
