import 'package:expensesapp/com/anand/screens/expenses_home_tab.dart';
import 'package:flutter/material.dart';

void main() => runApp(
    MaterialApp(
      // home: ExpensesAppHome(),
      home: ExpensesAppHomeTab(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'OpenSans',
      ),
    ),
); // MaterialApp
