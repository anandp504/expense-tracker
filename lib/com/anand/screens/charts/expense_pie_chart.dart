import 'dart:async';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:expensesapp/com/anand/domain/expense_models.dart';
import 'package:intl/intl.dart';
import 'package:random_color/random_color.dart';

import 'package:expensesapp/com/anand/db/db_helper.dart';

class PaymentModeSpendSlice {
  final String paymentMode;
  final double amount;
  final charts.Color color;

  PaymentModeSpendSlice({ this.paymentMode, this.amount, this.color });
}

class ExpensesPie extends StatefulWidget {

  // final StreamController<List<AggregateResult>> expenses;
  final Stream<List<AggregateResult>> expenses;

  ExpensesPie({ this.expenses });

  @override
  _ExpensesPieState createState() => _ExpensesPieState(expenses: this.expenses);
}

class _ExpensesPieState extends State<ExpensesPie> {

  // StreamController<List<AggregateResult>> expenses;
  Stream<List<AggregateResult>> expenses;
  final dateFormat = DateFormat("dd-MMM-yyyy");

  _ExpensesPieState({ this.expenses });

  @override
  void initState() {
    expenses = DatabaseHelper.instance.getPaymentModeAggregation().asStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AggregateResult>>(
        // stream: expenses.stream,
        stream: expenses,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<AggregateResult> records = snapshot.data;
            List<PaymentModeSpendSlice> paymentModeSpend = new List();
            RandomColor _randomColor = new RandomColor();

            for (int i = 0; i < records.length; i++) {
              paymentModeSpend.add(PaymentModeSpendSlice(
                  paymentMode: records[i].dimension,
                  amount: records[i].amount,
                  color: charts.ColorUtil.fromDartColor(
                      _randomColor.randomColor())));
            }

            // TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;
            return new charts.PieChart(
              [
                charts.Series<PaymentModeSpendSlice, String>(
                  id: 'expense_by_category',
                  displayName: "Spend by Payment Mode",
                  colorFn: (PaymentModeSpendSlice expense, _) => expense.color,
                  domainFn: (PaymentModeSpendSlice expense, _) =>
                      expense.paymentMode,
                  measureFn: (PaymentModeSpendSlice expense, _) =>
                      expense.amount,
                  labelAccessorFn: (PaymentModeSpendSlice expense, _) =>
                      "${expense.paymentMode}: ${expense.amount}",
                  data: paymentModeSpend,
                )
              ],
              animate: true,
              animationDuration: Duration(seconds: 1),
              // Configure the width of the pie slices to 60px. The remaining space in
              // the chart will be left as a hole in the center.
              defaultRenderer: new charts.ArcRendererConfig(
                  arcWidth: 60,
                  arcRendererDecorators: [
                    new charts.ArcLabelDecorator(
                        labelPosition: charts.ArcLabelPosition.inside),
                    // new charts.ArcLabelDecorator(),
                  ]),
            );
          }
        });
  }
}
