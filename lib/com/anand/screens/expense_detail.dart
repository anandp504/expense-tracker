import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:expensesapp/com/anand/domain/expense_models.dart';

class ExpenseDetail extends StatelessWidget {

  final Expense expense;

  const ExpenseDetail({
    Key key,
    @required this.expense
  }): assert(expense != null), super(key: key);

  _buildListTile(TextStyle titleStyle, String titleText, String subTitleText) {
    return ListTile(
      dense: true,
      title: Text(
        "$titleText",
        style: titleStyle,
      ),
      subtitle: Text(
        "$subTitleText",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("yMMMEd");
    String rupeeSymbol = "\u20B9";

    TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;

    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Detail",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              fontFamily: "RopaSans-Regular",
            )),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
            children: [
              Center(
                child: Container (
                  child: Column(
                      children: [
                        CircleAvatar(
                          child: Text(expense.paymentMode.mode.substring(0, 1)),
                          radius: 25.0,
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          "$rupeeSymbol ${expense.amount}",
                          style: TextStyle(fontSize: 25.0),
                        ),
                        SizedBox(height: 15.0),
                      ],
                    ),
                ),
              ),
              Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.check, color: Colors.green),
                        dense: true,
                        title: Text(
                          "Paid $rupeeSymbol ${expense.amount}",
                        ),
                        subtitle: Text(
                          dateFormat.format(expense.expenseDate),
                          // style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(),
                      _buildListTile(
                          titleStyle, "Category", "${expense.category.category}"),
                      _buildListTile(
                          titleStyle, "Description", "${expense.description}"),
                      _buildListTile(
                          titleStyle, "Bank", "${expense.paymentBank.bank}"),
                      _buildListTile(
                          titleStyle, "Mode", "${expense.paymentMode.mode}"),
                    ],
                  )
              ),
          ]
        ),
      ),
    );
  }
}
