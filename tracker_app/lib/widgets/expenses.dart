import 'package:flutter/material.dart';
import 'package:tracker_app/chart/chart.dart';
import 'package:tracker_app/widgets/expenses_list/expenses_list.dart';
import 'package:tracker_app/models/expense.dart';
import 'package:tracker_app/widgets/new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registerExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registerExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registerExpenses.indexOf(expense);
    setState(() {
      _registerExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expanse deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registerExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget maincontent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_registerExpenses.isNotEmpty) {
      maincontent = ExpensesList(
        expenses: _registerExpenses,
        onRemoveExpanse: _removeExpense,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter ExpenseTracker'),
          actions: [
            IconButton(
              onPressed: _openAddExpenseOverlay,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: width < 600
            ? Column(
                children: [
                  Chart(expenses: _registerExpenses),
                  Expanded(
                    child: maincontent,
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Chart(expenses: _registerExpenses),
                  ),
                  Expanded(
                    child: maincontent,
                  ),
                ],
              ),
      ),
    );
  }
}
