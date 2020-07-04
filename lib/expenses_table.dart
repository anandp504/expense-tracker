import 'package:expensesapp/com/anand/db/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:expensesapp/com/anand/domain/expenses.dart';

class ExpensesTable extends StatefulWidget {

  @override
  _ExpensesTableState createState() => _ExpensesTableState();
}

class _ExpensesTableState extends State<ExpensesTable> {

  Future<List<ExpenseRecord>> expenseRecords;
  var rowElementColor = Colors.grey[700];

  @override
  void initState() {
    super.initState();
    expenseRecords = DatabaseHelper.instance.getExpenses();
  }

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
        DataCell(Text(record.expenseDate, style: TextStyle(fontSize: 15.0, color: rowElementColor, fontFamily: "RopaSans-Regular"),),),
        DataCell(Text(record.category, style: TextStyle(fontSize: 15.0, color: rowElementColor, fontFamily: "RopaSans-Regular"),),),
        DataCell(Text(record.paymentBank.bank, style: TextStyle(fontSize: 15.0, color: rowElementColor, fontFamily: "RopaSans-Regular"),),),
        DataCell(Text('${record.amount}', style: TextStyle(fontSize: 15.0, color: rowElementColor, fontFamily: "RopaSans-Regular"),),),
      ],
    );
  }
}

