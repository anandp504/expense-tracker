import 'package:expensesapp/com/anand/screens/tabs/expenses_chart_view.dart';
import 'package:expensesapp/com/anand/screens/tabs/expense_list_scroll.dart';
import 'package:flutter/material.dart';
import 'package:expensesapp/com/anand/screens/expense_form.dart';
import 'package:expensesapp/com/anand/domain/expense_scroll_model.dart';
import 'package:expensesapp/com/anand/domain/expense_models.dart';
import 'package:expensesapp/com/anand/db/db_helper.dart';

class ExpensesAppHomeTab extends StatefulWidget {

  @override
  _ExpensesAppHomeTabState createState() => _ExpensesAppHomeTabState();
}

class _ExpensesAppHomeTabState extends State<ExpensesAppHomeTab> with SingleTickerProviderStateMixin {

  /*
  StreamController<List<ExpenseRecord>> expenseRecordsStream;
  StreamController<List<AggregateResult>> expensesBarChartStream;
  StreamController<List<AggregateResult>> expensesPieChartStream;
  */

  TabController _tabController;
  ExpensesModel expensesModel;
  Stream<List<AggregateResult>> expensesBarChartStream;
  Stream<List<AggregateResult>> expensesPieChartStream;

  /*
  void getChartData() {
    DatabaseHelper.instance.getCategoriesAggregation()?.then((records) => expensesBarChartStream.add(records));
    DatabaseHelper.instance.getPaymentModeAggregation().then((records) => expensesPieChartStream.add(records));
  }
  */

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    expensesModel = ExpensesModel();
    // DatabaseHelper.instance.getCategoriesAggregation()?.then((records) => expensesBarChartStream = Stream.value(records));
    // DatabaseHelper.instance.getPaymentModeAggregation().then((records) => expensesPieChartStream = Stream.value(records));
    /*
    expenseRecordsStream = new StreamController();
    expensesBarChartStream = new StreamController();
    expensesPieChartStream = new StreamController();
    getChartData();
    DatabaseHelper.instance.getExpenses().then((records) => expenseRecordsStream.add(records));
     */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Expenses",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              fontFamily: "RopaSans-Regular",
            )
        ),
        centerTitle: true,
        bottom: TabBar(
          unselectedLabelColor: Colors.white,
          labelColor: Colors.lime,
          tabs: [
            new Tab(icon: new Icon(Icons.list),),
            new Tab(icon: new Icon(Icons.insert_chart),),
          ],
          controller: _tabController,
        ),
      ),
      // body: ExpenseList(expenses: expenseRecordStream,),
      // body: ExpenseTileList(expenses: expenseRecordStream,),
      body: TabBarView(
        children: [
          // ExpenseTileList(),
          ExpenseTileListScroll(expensesModel: expensesModel,),
          ExpensesChartView(barChartStream: expensesBarChartStream, pieChartStream: expensesPieChartStream,),
        ],
        controller: _tabController,
      ),
      floatingActionButton: FloatingActionButton(
        child: IconButton(
          icon: Icon(Icons.add),
          tooltip: 'Add Expense',
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ExpenseDetailForm(appBarTitle: "Add Expense",);
            })).then((value) {
              setState(() {
                expensesModel.refresh();
                expensesBarChartStream = DatabaseHelper.instance.getCategoriesAggregation().asStream();
                expensesPieChartStream = DatabaseHelper.instance.getPaymentModeAggregation().asStream();
                /*
                DatabaseHelper.instance.getCategoriesAggregation()?.then((records) => expensesBarChartStream.add(records));
                DatabaseHelper.instance.getPaymentModeAggregation()?.then((records) => expensesPieChartStream.add(records));
                DatabaseHelper.instance.getExpenses()?.then((records) => expenseRecordsStream.add(records));
                 */
              });
            });
          }, // OnPressed
        ),
      ),
    );
  }
}