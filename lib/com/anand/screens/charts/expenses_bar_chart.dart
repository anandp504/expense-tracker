import 'dart:async';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:expensesapp/com/anand/domain/expense_models.dart';
import 'package:intl/intl.dart';
import 'package:random_color/random_color.dart';

import 'package:expensesapp/com/anand/db/db_helper.dart';

class CategorySpendSlice {
  final String category;
  final double amount;
  final charts.Color color;

  CategorySpendSlice({ this.category, this.amount, this.color });
}

class ExpensesBar extends StatefulWidget {

  final Stream<List<AggregateResult>> expenses;

  ExpensesBar({ this.expenses });

  @override
  _ExpensesBarState createState() => _ExpensesBarState(expenses: this.expenses);
}

class _ExpensesBarState extends State<ExpensesBar> {

  Stream<List<AggregateResult>> expenses;
  final dateFormat = DateFormat("dd-MMM-yyyy");

  _ExpensesBarState({ this.expenses });

  @override
  void initState() {
    expenses = DatabaseHelper.instance.getCategoriesAggregation().asStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AggregateResult>>(
        stream: expenses,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<AggregateResult> records = snapshot.data;
            List<CategorySpendSlice> categorySpend = new List();
            RandomColor _randomColor = new RandomColor();

            for (int i = 0; i < records.length; i++) {
              categorySpend.add(CategorySpendSlice(
                  category: records[i].dimension,
                  amount: records[i].amount,
                  color: charts.ColorUtil.fromDartColor(
                      _randomColor.randomColor())));
            }

            // TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;
            return new charts.BarChart(
              [
                charts.Series<CategorySpendSlice, String>(
                  id: 'expense_by_category',
                  displayName: "Spend by Category",
                  colorFn: (CategorySpendSlice expense, _) => expense.color,
                  domainFn: (CategorySpendSlice expense, _) => expense.category,
                  measureFn: (CategorySpendSlice expense, _) => expense.amount,
                  labelAccessorFn: (CategorySpendSlice expense, _) =>
                      expense.amount.toString(),
                  data: categorySpend,
                )
              ],
              vertical: false,
              barRendererDecorator: new charts.BarLabelDecorator<String>(),
              // domainAxis: new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
              animate: true,
              animationDuration: Duration(seconds: 1),
            );
          }
        });
  }
}
