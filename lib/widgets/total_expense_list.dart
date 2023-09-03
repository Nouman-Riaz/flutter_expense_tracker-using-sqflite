import 'package:expense_tracker/models/database_provider.dart';
import 'package:expense_tracker/widgets/expense_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class TotalExpensesList extends StatelessWidget {
  const TotalExpensesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (_, db, __) {
        var list = db.expenses;
        return list.isNotEmpty
            ? ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: list.length,
          itemBuilder: (_, i) => ExpenseCard(list[i]),
        )
            : const Center(
          child: Text('No Expense Found'),
        );
      },
    );
  }
}