import 'package:expensesapp/com/anand/db/db_helper.dart';
import 'package:expensesapp/com/anand/screens/charts/expense_pie_chart.dart';
import 'package:expensesapp/com/anand/screens/expenses_list.dart';
import 'package:expensesapp/com/anand/screens/charts/expenses_bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:expensesapp/com/anand/screens/expenses_table.dart';
import 'package:expensesapp/com/anand/screens/expense_form.dart';
import 'dart:async';
import 'package:expensesapp/com/anand/domain/expense_models.dart';

class ExpensesAppHome extends StatefulWidget {

  @override
  _ExpensesAppHomeState createState() => _ExpensesAppHomeState();
}

class _ExpensesAppHomeState extends State<ExpensesAppHome> {
  // final DatabaseHelper dbHelper = DatabaseHelper.instance;
  // Future<List<ExpenseRecord>> expenseRecords;
  // Widget expenseListWidget;

  // StreamController<List<AggregateResult>> expensesBarChartStream;
  // StreamController<List<AggregateResult>> expensesPieChartStream;

  Stream<List<AggregateResult>> expensesBarChartStream;
  Stream<List<AggregateResult>> expensesPieChartStream;

  /*
  void getExpenseList() async {
    await DatabaseHelper.instance.getCategoriesAggregation().then((records) {
      expensesBarChartStream.add(records);
    });

    await DatabaseHelper.instance.getPaymentModeAggregation().then((records) {
      expensesPieChartStream.add(records);
    });
  }
  */

  @override
  void initState() {
    super.initState();
    print("Initializing Expenses Home Widget");
    // expenseRecords = DatabaseHelper.instance.getExpenses();
    // expenseListWidget = ExpenseList(expenses: DatabaseHelper.instance.getExpenses(),);
    // expensesBarChartStream = new StreamController();
    // expensesPieChartStream = new StreamController();
    /*
    DatabaseHelper.instance.getCategoriesAggregation()?.then((records) {
      expensesBarChartStream.add(records);
    });

    DatabaseHelper.instance.getPaymentModeAggregation().then((records) {
      expensesPieChartStream.add(records);
    });
    */

    expensesBarChartStream = DatabaseHelper.instance.getCategoriesAggregation().asStream();
    expensesPieChartStream = DatabaseHelper.instance.getPaymentModeAggregation().asStream();
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
      ),
      // body: ExpenseList(expenses: expenseRecordStream,),
      // body: ExpenseTileList(expenses: expenseRecordStream,),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Card(
                elevation: 3.0,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                        children: [
                          Text("Spend by Category", style: Theme.of(context).textTheme.subtitle1,),
                          Expanded(child: ExpensesBar(expenses: expensesBarChartStream,)),
                        ]),
                ),
            ),
              ),
              Expanded(
                child: Card(
                  elevation: 3.0,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                        children: [
                          Text("Spend by Payment Mode", style: Theme.of(context).textTheme.subtitle1,),
                          Expanded(child: ExpensesPie(expenses: expensesPieChartStream,)),
                        ]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // backgroundColor: Colors.red[600],
        child: IconButton(
          icon: Icon(Icons.add),
          tooltip: 'Add Expense',
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return ExpenseDetailForm(appBarTitle: "Add Expense",);
            }))
                .then((value) {
              setState(() {
                // DatabaseHelper.instance.getCategoriesAggregation()?.then((records) => expensesBarChartStream.add(records));
                // DatabaseHelper.instance.getPaymentModeAggregation()?.then((records) => expensesPieChartStream.add(records));
                expensesBarChartStream = DatabaseHelper.instance.getCategoriesAggregation().asStream();
                expensesPieChartStream = DatabaseHelper.instance.getPaymentModeAggregation().asStream();
              });
            });
          }, // OnPressed
        ),
      ),
    );
  }
}