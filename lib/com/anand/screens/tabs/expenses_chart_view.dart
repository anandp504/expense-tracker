import 'package:flutter/material.dart';
import 'dart:async';

import 'package:expensesapp/com/anand/screens/charts/expense_pie_chart.dart';
import 'package:expensesapp/com/anand/screens/charts/expenses_bar_chart.dart';
import 'package:expensesapp/com/anand/domain/expense_models.dart';


class ExpensesChartView extends StatefulWidget {

  final Stream<List<AggregateResult>> barChartStream;
  final Stream<List<AggregateResult>> pieChartStream;

  ExpensesChartView({this.barChartStream, this.pieChartStream});

  @override
  _ExpensesChartViewState createState() => _ExpensesChartViewState(expensesBarChartStream: this.barChartStream, expensesPieChartStream: this.pieChartStream);
}

class _ExpensesChartViewState extends State<ExpensesChartView> {

  Stream<List<AggregateResult>> expensesBarChartStream;
  Stream<List<AggregateResult>> expensesPieChartStream;

  _ExpensesChartViewState({this.expensesBarChartStream, this.expensesPieChartStream});

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
