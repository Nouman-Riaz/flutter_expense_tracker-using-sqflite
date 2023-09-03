import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/constants/icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/models/database_provider.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({Key? key}) : super(key: key);

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {

  final amount = TextEditingController();
  final title = TextEditingController();
  DateTime? dateTime;
  String initialValue = 'Other';
  final _formKey = GlobalKey<FormState>();

  pickDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime.now());
    if (pickedDate != null) {
      setState(() {
        dateTime = pickedDate;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context,listen: false);
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                        controller: title,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          //hintText: 'Expense title',
                          labelText: 'Title',
                          //border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter title';
                          }
                          return null;
                        }),
                    const SizedBox(height: 20.0),
                    TextFormField(
                        controller: amount,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          //hintText: 'Expense Amount',
                          labelText: 'Amount',
                          //border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Amount';
                          }
                          return null;
                        }),
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                      dateTime != null ? DateFormat('MMMM dd, yyyy').format(dateTime!): 'Select Date'),
                ),
                IconButton(
                  onPressed: () => pickDate(),
                  icon: const Icon(Icons.calendar_month_outlined),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Expanded(child: Text('Category')),
                Expanded(
                  flex: 2,
                  child: DropdownButton(
                    items: icons.keys
                        .map(
                          (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ),
                    )
                        .toList(),
                    value: initialValue,
                    onChanged: (newValue) {
                      setState(() {
                        initialValue = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final file = Expense(
                      dateTime: dateTime != null ? dateTime! : DateTime.now(),
                      title: title.text,
                      id: 0,
                      category: initialValue,
                      amount: double.parse(amount.text));
                  provider.addExpense(file);
                  Navigator.of(context).pop();
                }
              },
              child: const Center(child: Text('Add')),
            )
          ],
        ),
      ),
    );
  }
}
