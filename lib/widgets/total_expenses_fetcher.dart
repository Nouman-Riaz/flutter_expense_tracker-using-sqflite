import 'package:expense_tracker/models/database_provider.dart';
import 'package:expense_tracker/widgets/expense_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/widgets/total_expense_list.dart';

class TotalExpensesFetcher extends StatefulWidget {
  const TotalExpensesFetcher({super.key});

  @override
  State<TotalExpensesFetcher> createState() => _TotalExpensesFetcherState();
}

class _TotalExpensesFetcherState extends State<TotalExpensesFetcher> {
  late Future _allExpensesList;

  Future _getAllExpenses() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.fetchAllExpenses();
  }

  @override
  void initState() {
    super.initState();
    _allExpensesList = _getAllExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _allExpensesList,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: const [
                  ExpenseSearch(),
                  Expanded(child: TotalExpensesList()),
                ],
              ),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}