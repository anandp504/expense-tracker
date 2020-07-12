import 'dart:async';
import 'package:flutter/material.dart';

import 'package:expensesapp/com/anand/domain/expense_models.dart';
import 'package:expensesapp/com/anand/db/db_helper.dart';

class ExpensesModel {
  Stream<List<Expense>> stream;
  bool hasMore;

  StreamController<List<Expense>> _controller;
  bool _isLoading;
  List<Expense> _expenseData;
  int totalRecords = 0;
  int offset = -8;
  int limit = 8;
  int loadedRecords = 0;

  ExpensesModel() {
    _expenseData = new List();
    _controller = new StreamController<List<Expense>>.broadcast();
    _isLoading = false;
    stream = _controller.stream.map((List<Expense> expenseRecords) => expenseRecords);
    hasMore = true;
    refresh();
  }

  Future<void> refresh() {
    return loadMore(clearCachedData: true);
  }

  Future<void> loadMore({bool clearCachedData = false}) {
    offset = offset + limit;
    if (clearCachedData) {
      loadedRecords = 0;
      _expenseData = List();
      hasMore = true;
    }

    if (_isLoading || !hasMore) {
      return Future.value();
    }

    _isLoading = true;

    // print("Offset = $offset | hasMore = $hasMore");

    return DatabaseHelper.instance.getExpenseRecordCount()?.then((resultCount) {
      totalRecords = resultCount;
      // print("Total Records = $totalRecords");
      DatabaseHelper.instance.getExpensesWithOffset(limit, offset)?.then((data) {
        _isLoading = false;
        _expenseData.addAll(data);
        loadedRecords = loadedRecords + data.length;
        // print("data length = ${_expenseData.length}");
        // print("loaded records = $loadedRecords | More records to load = ${totalRecords - loadedRecords}");
        // hasMore = (_expenseData.length < (totalRecords - loadedRecords));
        hasMore = (totalRecords - loadedRecords) != 0;
        _controller.add(_expenseData);
      });
    });
  }

}