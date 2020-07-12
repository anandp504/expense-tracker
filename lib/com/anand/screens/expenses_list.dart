import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:expensesapp/com/anand/domain/expense_models.dart';
import 'package:expensesapp/com/anand/db/db_helper.dart';


class ExpenseTileList extends StatefulWidget {

  ExpenseTileList();

  @override
  _ExpenseTileListState createState() => _ExpenseTileListState();
}

class _ExpenseTileListState extends State<ExpenseTileList> {

  StreamController<List<Expense>> expenseRecordsStream;
  // final dateFormat = DateFormat("dd-MMM-yyyy");
  final dateFormat = DateFormat("MMMMd");
  final String rupeeSymbol = "\u20B9";

  @override
  void initState() {
    super.initState();
    expenseRecordsStream = new StreamController();
    DatabaseHelper.instance.getExpenses()?.then((records) => expenseRecordsStream.add(records));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Expense>>(
      stream: expenseRecordsStream.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Expense> records = snapshot.data;
          var dtFormat = DateFormat("dd-MM-yy HH:mm:ss");
          for(int i = 0; i < records.length; i++) {
            print("${records[i].category.category} | ${dtFormat.format(records[i].expenseDate)}");
          }

          TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;
          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (BuildContext context, int position) {
              return Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  leading: CircleAvatar(
                        child: Text(records[position].paymentMode.mode.substring(0, 1)),
                      ),
                  dense: true,
                  title: Text(
                    records[position].category.category,
                    style: titleStyle,
                  ),
                  subtitle: Row(
                    children: [
                      Text(dateFormat.format(records[position].expenseDate), style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(width: 10.0),
                      Text(records[position].description??""),
                    ],
                  ),
                  trailing: Text(
                    "$rupeeSymbol ${records[position].amount}",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                  ),
                  onTap: () {
                    // debugPrint("ListTile Tapped");
                    // navigateToDetail(this.noteList[position],'Edit Note');
                  },
                ),
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}