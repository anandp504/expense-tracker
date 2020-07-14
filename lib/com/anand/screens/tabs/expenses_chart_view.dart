import 'package:flutter/material.dart';
import 'dart:async';

import 'package:expensesapp/com/anand/db/db_helper.dart';
import 'package:expensesapp/com/anand/screens/charts/expense_pie_chart.dart';
import 'package:expensesapp/com/anand/screens/charts/expenses_bar_chart.dart';
import 'package:expensesapp/com/anand/domain/expense_models.dart';


class ExpensesChartView extends StatefulWidget {
  @override
  _ExpensesChartViewState createState() => _ExpensesChartViewState();
}

class _ExpensesChartViewState extends State<ExpensesChartView> {

  StreamController<List<AggregateResult>> expensesBarChartStream;
  StreamController<List<AggregateResult>> expensesPieChartStream;

  void getChartData() {
    DatabaseHelper.instance.getCategoriesAggregation()?.then((records) => expensesBarChartStream.add(records));
    DatabaseHelper.instance.getPaymentModeAggregation().then((records) => expensesPieChartStream.add(records));
  }

  @override
  void initState() {
    super.initState();
    expensesBarChartStream = new StreamController();
    expensesPieChartStream = new StreamController();
    getChartData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
