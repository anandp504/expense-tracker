import 'dart:async';

import 'package:flutter/material.dart';
import 'package:expensesapp/com/anand/domain/expenses.dart';
import 'package:intl/intl.dart';

class ExpenseList extends StatefulWidget {

  // final Future<List<ExpenseRecord>> expenses;
  final StreamController<List<ExpenseRecord>> expenses;
  ExpenseList({ this.expenses });

  @override
  _ExpenseListState createState() => _ExpenseListState(expenses: this.expenses);
}

class _ExpenseListState extends State<ExpenseList> {

  // Future<List<ExpenseRecord>> expenses;
  StreamController<List<ExpenseRecord>> expenses;
  final dateFormat = DateFormat("dd-MMM-yyyy");

  _ExpenseListState({ this.expenses });

  var rowElementColor = Colors.grey[700];
  // Future<List<ExpenseRecord>> expenseRecords;
  // StreamController<List<ExpenseRecord>> expenseRecordStream;

  /*
  void getExpenseList() async =>
      await DatabaseHelper.instance.getExpenses().then((records) {
        expenseRecordStream.add(records);
      });
   */

  /*
  void getExpenseList() async =>
      await expenses.then((records) {
        expenseRecordStream.add(records);
      });
  */

  @override
  void initState() {
    super.initState();
    // expenseRecords = DatabaseHelper.instance.getExpenses();
    // expenseRecordStream = StreamController<List<ExpenseRecord>>();
    // getExpenseList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ExpenseRecord>>(
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

  /*
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExpenseRecord>>(
        future: expenseRecords,
        builder: (BuildContext context,
            AsyncSnapshot<List<ExpenseRecord>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('No Expense data found', style: TextStyle(color: Colors.grey[600]),);
            case ConnectionState.waiting:
              return Text('Loading Expense data', style: TextStyle(color: Colors.grey[600]),);
            case ConnectionState.done:
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: FittedBox(
                  child: DataTable(
                    columns: createTableHeader(),
                    rows: snapshot.data.map((expense) => createExpenseRow(expense)).toList(),
                  ),
                ),
              );
            default:
              return Text('No Expense data found', style: TextStyle(color: Colors.grey[600]),);
          }
        }
    );
  }
  */

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

  DataRow createExpenseRow(ExpenseRecord record) {
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

