import 'package:expense_tracker/widgets/expense_chart.dart';
import 'package:expense_tracker/widgets/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/models/database_provider.dart';

class ExpenseFetcher extends StatefulWidget {
  final String category;
  const ExpenseFetcher(this.category, {super.key});

  @override
  State<ExpenseFetcher> createState() => _ExpenseFetcherState();
}

class _ExpenseFetcherState extends State<ExpenseFetcher> {
  late Future _expenseList;

  Future _getExpenseList() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.fetchExpenses(widget.category);
  }

  @override
  void initState() {
    super.initState();
    // fetch the list and set it to _expenseList
    _expenseList = _getExpenseList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _expenseList,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // if connection is done then check for errors or return the result
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(children: [
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: ExpenseChart(widget.category),
                  ),
                  const Expanded(child: ExpenseList())
                ]));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
