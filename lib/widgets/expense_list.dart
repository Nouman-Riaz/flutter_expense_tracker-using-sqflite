import 'package:expense_tracker/widgets/expense_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/models/database_provider.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (_, db, __) {
        // get the categories
        var list = db.expenses;
        return list.isNotEmpty
            ? ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) => ExpenseCard(list[i]))
            : const Center(
          child: Text('No Expenses Added'),
        );
      },
    );
  }
}