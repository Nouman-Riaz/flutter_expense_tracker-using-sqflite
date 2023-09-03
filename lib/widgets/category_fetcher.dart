import 'package:expense_tracker/widgets/category_list.dart';
import 'package:expense_tracker/widgets/total_expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/models/database_provider.dart';
import 'package:expense_tracker/widgets/chart.dart';

class CategoryFetcher extends StatefulWidget {
  const CategoryFetcher({super.key});

  @override
  State<CategoryFetcher> createState() => _CategoryFetcherState();
}

class _CategoryFetcherState extends State<CategoryFetcher> {
  late Future _categoryList;

  Future _getCategoryList() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.fetchCategories();
  }

  @override
  void initState() {
    super.initState();
    // fetch the list and set it to _categoryList
    _categoryList = _getCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _categoryList,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // if connection is done then check for errors or return the result
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.3,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Chart(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Expenses',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(TotalExpenses.name);
                        },
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                ),

                const Expanded(child: CategoryList()),
              ],
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}