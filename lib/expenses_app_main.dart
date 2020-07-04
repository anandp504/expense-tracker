import 'package:expensesapp/com/anand/db/db_helper.dart';
import 'package:expensesapp/com/anand/domain/expenses.dart';
import 'package:flutter/material.dart';
import 'package:expensesapp/expenses_table.dart';
import 'package:expensesapp/expense_form.dart';

void main() => runApp(
    MaterialApp(
      home: ExpensesAppHome(),
      routes: <String, WidgetBuilder> {
        "/ExpenseForm": (BuildContext context) => ExpenseForm()
      },
    ),
); // MaterialApp

class ExpensesAppHome extends StatefulWidget {

  @override
  _ExpensesAppHomeState createState() => _ExpensesAppHomeState();
}

class _ExpensesAppHomeState extends State<ExpensesAppHome> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  /*
  List<ExpenseRecord> expenses = [
    ExpenseRecord.c1(expenseDate: "2020-06-26", description: "", category: "Milk", paymentBank: "CITIBANK", paymentMode: "UPI", amount: 30),
    ExpenseRecord.c1(expenseDate: "2020-06-25", description: "", category: "Biscuit", paymentBank: "ICICI", paymentMode: "UPI", amount: 100),
    ExpenseRecord.c1(expenseDate: "2020-06-24", description: "", category: "Rice", paymentBank: "CITIBANK", paymentMode: "UPI", amount: 60),
  ];
   */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
            "Expenses",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              fontFamily: "RopaSans-Regular",
            )
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent[600],
      ),
      body: ExpensesTable(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[600],
        child: IconButton(
          icon: Icon(Icons.add),
          tooltip: 'Add Expense',
          onPressed: () {
            Navigator.of(context).pushNamed("/ExpenseForm");
          }, // OnPressed
        ),
      ),
    );
  }
}
