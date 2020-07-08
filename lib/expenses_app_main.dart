import 'package:expensesapp/com/anand/db/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:expensesapp/expenses_table.dart';
import 'package:expensesapp/expense_form.dart';
import 'dart:async';
import 'package:expensesapp/com/anand/domain/expenses.dart';

void main() => runApp(
    MaterialApp(
      home: ExpensesAppHome(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      routes: <String, WidgetBuilder> {
        "/ExpenseForm": (BuildContext context) => ExpenseDetail()
      },
    ),
); // MaterialApp

class ExpensesAppHome extends StatefulWidget {

  @override
  _ExpensesAppHomeState createState() => _ExpensesAppHomeState();
}

class _ExpensesAppHomeState extends State<ExpensesAppHome> {
  // final DatabaseHelper dbHelper = DatabaseHelper.instance;
  // Future<List<ExpenseRecord>> expenseRecords;
  // Widget expenseListWidget;

  StreamController<List<ExpenseRecord>> expenseRecordStream;

  void getExpenseList() async =>
      await DatabaseHelper.instance.getExpenses().then((records) {
        expenseRecordStream.add(records);
      });

  @override
  void initState() {
    super.initState();
    print("Initializing Expenses Home Widget");
    // expenseRecords = DatabaseHelper.instance.getExpenses();
    // expenseListWidget = ExpenseList(expenses: DatabaseHelper.instance.getExpenses(),);
    expenseRecordStream = new StreamController();
    DatabaseHelper.instance.getExpenses()?.then((records) => expenseRecordStream.add(records));
  }

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
        // backgroundColor: Colors.blueAccent[600],
      ),
      body: ExpenseList(expenses: expenseRecordStream,),
      floatingActionButton: FloatingActionButton(
        // backgroundColor: Colors.red[600],
        child: IconButton(
          icon: Icon(Icons.add),
          tooltip: 'Add Expense',
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return ExpenseDetail(appBarTitle: "Add Expense",);
            }))
            .then((value) {
              setState(() {
                print("Obtaining expense records from DB...");
                // expenseListWidget = ExpenseList(expenses: DatabaseHelper.instance.getExpenses());
                DatabaseHelper.instance.getExpenses()?.then((records) => expenseRecordStream.add(records));
              });
            });
          }, // OnPressed
        ),
      ),
    );
  }
}
