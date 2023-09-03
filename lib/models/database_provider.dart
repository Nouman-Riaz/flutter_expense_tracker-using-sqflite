import 'package:expense_tracker/models/expense_category.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:expense_tracker/constants/icons.dart';
import 'expense.dart';

class DatabaseProvider with ChangeNotifier {
  String _searchText = '';
  String get searchText => _searchText;
  set searchText(String value) {
    _searchText = value;
    notifyListeners();
    // when the value of the search text changes it will notify the widgets.
  }

  // in-app memory for holding the Expense categories temporarily
  List<ExpenseCategory> _categories = [];
  List<ExpenseCategory> get categories => _categories;

  List<Expense> _expenses = [];
  // when the search text is empty, return whole list, else search for the value
  List<Expense> get expenses {
    return _searchText != ''
        ? _expenses
        .where((e) =>
        e.title.toLowerCase().contains(_searchText.toLowerCase()))
        .toList()
        : _expenses;
  }

  Database? _database;
  Future<Database> get database async {
    final directory = await getDatabasesPath();
    const name = 'expense.db';
    // full path
    final path = join(directory, name);
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
    return _database!;
  }

  static const categoryTable = 'categoryTable';
  static const expenseTable = 'expenseTable';

  Future<void> _createDB(Database DB, int version) async {
    await DB.transaction((txn) async {
      await txn.execute('''CREATE TABLE $categoryTable(
      title TEXT,
      entries INTEGER,
      totalAmount TEXT
      )''');
      await txn.execute('''CREATE TABLE $expenseTable(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      amount TEXT,
      dateTime TEXT,
      category TEXT
      )''');

      //insert the initial categories
      for (int i = 0; i < icons.length; i++) {
        await txn.insert(categoryTable, {
          'title': icons.keys.toList()[i],
          'entries': 0,
          'totalAmount': (0.0).toString()
        });
      }
    });
  }

  Future<List<ExpenseCategory>> fetchCategories() async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(categoryTable).then((value) {
        final converted = List<Map<String, dynamic>>.from(value);
        List<ExpenseCategory> nList = List.generate(converted.length,
            (index) => ExpenseCategory.fromString(converted[index]));
        _categories = nList;
        return _categories;
      });
    });

  }

  Future<List<Expense>> fetchExpenses(String category) async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(expenseTable,
        where: 'category ==?',
        whereArgs: [category],).then((value) {
        final converted = List<Map<String, dynamic>>.from(value);
        List<Expense> nList = List.generate(converted.length,
                (index) => Expense.fromString(converted[index]));
        _expenses = nList;
        return _expenses;
      });
    });

  }

  ExpenseCategory findCategory(String title) {
    return _categories.firstWhere((element) => element.title == title);
  }

  double calculateTotalExpenses(){
    return _categories.fold(0.0, (previousValue, element) => previousValue+element.totalAmount);
  }
  Future<void> addExpense(Expense expense) async {
    final db = await database;
    return await db.transaction((txn) async {
      await txn
          .insert(expenseTable, expense.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace)
          .then((value) {
        final file = Expense(
            dateTime: expense.dateTime,
            title: expense.title,
            id: value,
            category: expense.category,
            amount: expense.amount);
        _expenses.add(file);
        notifyListeners();
        //var ex = calculateEntriesAndAmount(expense.category);
        var ex = findCategory(expense.category);
        updateCategory(expense.category, ex.entries+1, ex.totalAmount+expense.amount);
      });
    });
  }

  Future<void> updateCategory(
      String category, int entries, double totalAmount) async {
    final db = await database;
    return await db.transaction((txn) async {
      await txn
          .update(
            categoryTable,
            {'entries': entries, 'totalAmount': totalAmount},
            where: 'title ==?',
            whereArgs: [category],
          )
          .then((_) {
            var file = _categories.firstWhere((element) => element.title==category);
            file.entries = entries;
            file.totalAmount = totalAmount;
            notifyListeners();
      });
    });
  }

  List<Map<String, dynamic>> calculateWeekExpenses() {
    List<Map<String, dynamic>> data = [];

    // we know that we need 7 entries
    for (int i = 0; i < 7; i++) {
      // 1 total for each entry
      double total = 0.0;
      // subtract i from today to get previous dates.
      final weekDay = DateTime.now().subtract(Duration(days: i));

      // check how many transacitons happened that day
      for (int j = 0; j < _expenses.length; j++) {
        if (_expenses[j].dateTime.year == weekDay.year &&
            _expenses[j].dateTime.month == weekDay.month &&
            _expenses[j].dateTime.day == weekDay.day) {
          // if found then add the amount to total
          total += _expenses[j].amount;
        }
      }

      // add to a list
      data.add({'day': weekDay, 'amount': total});
    }
    // return the list
    return data;
  }

  Map<String, dynamic> calculateEntriesAndAmount(String category) {
    double total = 0.0;
    var list = _expenses.where((element) => element.category == category);
    for (final i in list) {
      total += i.amount;
    }
    return {'entries': list.length, 'totalAmount': total};
  }

  Future<void> deleteExpense(int expId, String category, double amount) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete(expenseTable, where: 'id == ?', whereArgs: [expId]).then((_) {
        // remove from in-app memory too
        _expenses.removeWhere((element) => element.id == expId);
        notifyListeners();
        // we have to update the entries and totalamount too

        var ex = findCategory(category);
        updateCategory(category, ex.entries - 1, ex.totalAmount - amount);
      });
    });
  }

  Future<List<Expense>> fetchAllExpenses() async {
    final db = await database;
    return await db.transaction((txn) async {
      return await txn.query(expenseTable).then((data) {
        final converted = List<Map<String, dynamic>>.from(data);
        List<Expense> nList = List.generate(
            converted.length, (index) => Expense.fromString(converted[index]));
        _expenses = nList;
        return _expenses;
      });
    });
  }

}
