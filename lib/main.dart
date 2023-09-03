import 'package:expense_tracker/screens/category_screen.dart';
import 'package:expense_tracker/screens/expense_screen.dart';
import 'package:expense_tracker/widgets/total_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/database_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => DatabaseProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      initialRoute: CategoryScreen.name,
      routes: {
        CategoryScreen.name: (_) => const CategoryScreen(),
        ExpenseScreen.name: (_) => const ExpenseScreen(),
        TotalExpenses.name: (_) => const TotalExpenses(),
      },
    );
  }
}
