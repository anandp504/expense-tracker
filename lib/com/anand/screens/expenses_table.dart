import 'dart:async';

import 'package:flutter/material.dart';
import 'package:expensesapp/com/anand/domain/expense_models.dart';
import 'package:intl/intl.dart';

class ExpenseList extends StatefulWidget {

  final StreamController<List<Expense>> expenses;
  ExpenseList({ this.expenses });

  @override
  _ExpenseListState createState() => _ExpenseListState(expenses: this.expenses);
}

class _ExpenseListState extends State<ExpenseList> {

  StreamController<List<Expense>> expenses;
  final dateFormat = DateFormat("dd-MMM-yyyy");
  var rowElementColor = Colors.grey[700];

  _ExpenseListState({ this.expenses });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Expense>>(
      stream: expenses.stream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FittedBox(
            child: DataTable(
              columns: createTableHeader(),
              rows: snapshot.data.map((expense) => createExpenseRow(expense)).toList(),
            ),
          ),
        )
        : Center(
            child: CircularProgressIndicator(),
        );
      },
    );
  }

  List<DataColumn> createTableHeader() {
    return [
      DataColumn(label: columnLabel('Date'),),
      DataColumn(label: columnLabel('Category'),),
      DataColumn(label: columnLabel('Bank'),),
      DataColumn(label: columnLabel('Amount'),),
    ].toList();
  }

  Container columnLabel(String columnLabel) {
    return Container(
      child: Text(columnLabel, style: TextStyle(fontSize: 15.0, color: Colors.black, fontFamily: "RopaSans-Regular"),),
    );
  }

  DataRow createExpenseRow(Expense record) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(dateFormat.format(record.expenseDate), style: TextStyle(fontSize: 15.0, color: rowElementColor, fontFamily: "RopaSans-Regular"),),),
        DataCell(Text(record.category.category, style: TextStyle(fontSize: 15.0, color: rowElementColor, fontFamily: "RopaSans-Regular"),),),
        DataCell(Text(record.paymentBank.bank, style: TextStyle(fontSize: 15.0, color: rowElementColor, fontFamily: "RopaSans-Regular"),),),
        DataCell(Text('${record.amount}', style: TextStyle(fontSize: 15.0, color: rowElementColor, fontFamily: "RopaSans-Regular"),),),
      ],
    );
  }
}

