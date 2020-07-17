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

  TabController _tabController;
  ExpensesModel expensesModel;
  Stream<List<AggregateResult>> expensesBarChartStream;
  Stream<List<AggregateResult>> expensesPieChartStream;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
    expensesModel = ExpensesModel();
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
              });
            });
          }, // OnPressed
        ),
      ),
    );
  }
}