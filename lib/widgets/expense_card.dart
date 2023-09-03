import 'package:expense_tracker/constants/icons.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/confirm_box.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  const ExpenseCard(this.expense, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(expense.id),
      confirmDismiss: (_) async {
        showDialog(
          context: context,
          builder: (_) => ConfirmBox(exp: expense),
        );
      },
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icons[expense.category]),
        ),
        title: Text(expense.title),
        subtitle: Text(DateFormat('MMMM dd, yyyy').format(expense.dateTime)),
        trailing: Text(NumberFormat.currency(locale: 'en_PK', symbol: '₨ ')
            .format(expense.amount)),
      ),
    );
  }
}
