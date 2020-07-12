import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:expensesapp/com/anand/domain/expense_models.dart';
import 'package:expensesapp/com/anand/domain/expense_scroll_model.dart';
import 'package:expensesapp/com/anand/screens/expense_summary_card.dart';


class ExpenseTileListScroll extends StatefulWidget {

  ExpenseTileListScroll();

  @override
  _ExpenseTileListScrollState createState() => _ExpenseTileListScrollState();
}

class _ExpenseTileListScrollState extends State<ExpenseTileListScroll> {

  final scrollController = ScrollController();
  ExpensesModel expensesModel;
  final dateFormat = DateFormat("MMMMd");
  final String rupeeSymbol = "\u20B9";

  @override
  void initState() {
    expensesModel = new ExpensesModel();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        expensesModel.loadMore();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Expense>>(
      stream: expensesModel.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          List<Expense> records = snapshot.data;
          return RefreshIndicator(
            onRefresh: expensesModel.refresh,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              controller: scrollController,
              separatorBuilder: (context, index) => Divider(),
              itemCount: records.length + 1,
              itemBuilder: (BuildContext context, int position) {
                if (position < records.length) {
                  return ExpenseSummaryCard(expense: records[position]);
                } else if(expensesModel.hasMore) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: Center(child: Text('Nothing more to load...')),
                  );
                }
              },
            ),
          );
        }
      },
    );
  }
}
