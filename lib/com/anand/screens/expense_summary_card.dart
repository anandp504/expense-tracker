import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:expensesapp/com/anand/domain/expense_models.dart';
import 'package:expensesapp/com/anand/screens/expense_detail.dart';

class ExpenseSummaryCard extends StatelessWidget {

  final Expense expense;

  const ExpenseSummaryCard({
    Key key,
    @required this.expense
  }): assert(expense != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("MMMMd");
    String rupeeSymbol = "\u20B9";
    TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;

    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: ListTile(
        leading: CircleAvatar(
          child: Text(expense.paymentMode.mode.substring(0, 1)),
        ),
        dense: true,
        title: Text(
          expense.category.category,
          style: titleStyle,
        ),
        subtitle: Row(
          children: [
            Text(dateFormat.format(expense.expenseDate), style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(width: 10.0),
            Text(expense.description??""),
          ],
        ),
        trailing: Text(
          "$rupeeSymbol ${expense.amount}",
          style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ExpenseDetail(expense: expense,);
          }));
        },
      ),
    );
  }
}
