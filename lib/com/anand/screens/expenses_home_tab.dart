import 'package:expensesapp/com/anand/db/db_helper.dart';
import 'package:expensesapp/com/anand/screens/charts/expense_pie_chart.dart';
import 'package:expensesapp/com/anand/screens/tabs/expenses_chart_view.dart';
import 'package:expensesapp/com/anand/screens/expenses_list.dart';
import 'package:expensesapp/com/anand/screens/tabs/expense_list_scroll.dart';
import 'package:expensesapp/com/anand/screens/charts/expenses_bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:expensesapp/com/anand/screens/expenses_table.dart';
import 'package:expensesapp/com/anand/screens/expense_form.dart';
import 'dart:async';
import 'package:expensesapp/com/anand/domain/expense_models.dart';

class ExpensesAppHomeTab extends StatefulWidget {

  @override
  _ExpensesAppHomeTabState createState() => _ExpensesAppHomeTabState();
}

class _ExpensesAppHomeTabState extends State<ExpensesAppHomeTab> with SingleTickerProviderStateMixin {

  /*
  StreamController<List<ExpenseRecord>> expenseRecordsStream;
  StreamController<List<AggregateResult>> expensesBarChartStream;
  StreamController<List<AggregateResult>> expensesPieChartStream;
  */

  TabController _tabController;

  /*
  void getChartData() {
    DatabaseHelper.instance.getCategoriesAggregation()?.then((records) => expensesBarChartStream.add(records));
    DatabaseHelper.instance.getPaymentModeAggregation().then((records) => expensesPieChartStream.add(records));
  }
  */

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    /*
    expenseRecordsStream = new StreamController();
    expensesBarChartStream = new StreamController();
    expensesPieChartStream = new StreamController();
    getChartData();
    DatabaseHelper.instance.getExpenses().then((records) => expenseRecordsStream.add(records));
     */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.lime,
          tabs: [
            new Tab(icon: new Icon(Icons.list),),
            new Tab(icon: new Icon(Icons.insert_chart),),
          ],
          controller: _tabController,
        ),
      ),
      // body: ExpenseList(expenses: expenseRecordStream,),
      // body: ExpenseTileList(expenses: expenseRecordStream,),
      body: TabBarView(
        children: [
          // ExpenseTileList(),
          ExpenseTileListScroll(),
          ExpensesChartView(),
        ],
        controller: _tabController,
      ),
      floatingActionButton: FloatingActionButton(
        child: IconButton(
          icon: Icon(Icons.add),
          tooltip: 'Add Expense',
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ExpenseDetailForm(appBarTitle: "Add Expense",);
            })).then((value) {
              setState(() {
                /*
                DatabaseHelper.instance.getCategoriesAggregation()?.then((records) => expensesBarChartStream.add(records));
                DatabaseHelper.instance.getPaymentModeAggregation()?.then((records) => expensesPieChartStream.add(records));
                DatabaseHelper.instance.getExpenses()?.then((records) => expenseRecordsStream.add(records));
                 */
              });
            });
          }, // OnPressed
        ),
      ),
    );
  }
}