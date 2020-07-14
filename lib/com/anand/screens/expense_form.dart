import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import 'package:expensesapp/com/anand/domain/expense_models.dart';
import 'package:expensesapp/com/anand/db/db_helper.dart';

class ExpenseDetailForm extends StatefulWidget {

  final String appBarTitle;

  ExpenseDetailForm({ this.appBarTitle });

  @override
  _ExpenseDetailFormState createState() => _ExpenseDetailFormState(appBarTitle: this.appBarTitle);
}

class _ExpenseDetailFormState extends State<ExpenseDetailForm> {

  String appBarTitle;
  _ExpenseDetailFormState({ this.appBarTitle });

  var _formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat("dd-MMM-yy HH:mm");
  final double sizedBoxHeight = 5.0;

  StreamController<List<PaymentMode>> paymentModesStream;
  StreamController<List<PaymentBank>> paymentBanksStream;
  StreamController<List<Category>> categoriesStream;

  DateTime date;

  Expense _expenseRecord = Expense();
  final TextEditingController _categoriesController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    paymentModesStream = new StreamController();
    paymentBanksStream = new StreamController();
    categoriesStream = new StreamController();
    DatabaseHelper.instance.getPaymentModes()?.then((res) => paymentModesStream.add(res));
    DatabaseHelper.instance.getBanks()?.then((res) => paymentBanksStream.add(res));
    DatabaseHelper.instance.getCategories()?.then((res) => categoriesStream.add(res));
  }

  Widget _buildPaymentBanksDropDown() {
    return StreamBuilder<List<PaymentBank>>(
        stream: paymentBanksStream.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<DropdownMenuItem<PaymentBank>> bankDropDown = new List();
            List<PaymentBank> bankData = snapshot.data;
            for (int i = 0; i < bankData.length; i++) {
              bankDropDown.add(DropdownMenuItem(
                child: Text(bankData[i].bank),
                value: bankData[i],
              ));
            }
            return SearchableDropdown.single(
              items: bankDropDown,
              value: _expenseRecord.paymentBank,
              label: "Payment Bank",
              onChanged: (value) {
                setState(() {
                  _expenseRecord.paymentBank = value;
                });
              },
              isExpanded: true,
              validator: (PaymentBank item) {
                if (item == null)
                  return "Please enter a payment bank";
                else
                  return null;
              },
            );
          }
        });
  }

  Widget _buildPaymentModeDropDown(BuildContext context) {
    return StreamBuilder<List<PaymentMode>>(
      stream: paymentModesStream.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          List<DropdownMenuItem<PaymentMode>> paymentModeDropDown = new List();
          List<PaymentMode> modeData = snapshot.data;
          for (int i = 0; i < modeData.length; i++) {
            paymentModeDropDown.add(DropdownMenuItem(
              child: Text(modeData[i].mode),
              value: modeData[i],
            ));
          }
          return SearchableDropdown.single(
            items: paymentModeDropDown,
            value: _expenseRecord.paymentMode,
            // searchHint: "Search for a Payment Mode",
            label: "Payment Mode",
            // style: DefaultTextStyle.of(context).style,
            onChanged: (item) {
              setState(() {
                _expenseRecord.paymentMode = item;
              });
            },
            isExpanded: true,
            validator: (item) {
              if (item == null)
                return "Please enter a payment mode";
              else
                return null;
            },
          );
        }
      },
    );
  }

  Widget _buildCategoriesDropDown(BuildContext context) {
    return StreamBuilder<List<Category>>(
        stream: categoriesStream.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<Category> categoriesList = snapshot.data;
            return TypeAheadFormField<Category>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _categoriesController,
                // style: DefaultTextStyle.of(context).style,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Category'),
              ),
              suggestionsCallback: (pattern) {
                List<Category> filteredCategories = new List();
                filteredCategories.addAll(categoriesList);
                filteredCategories.retainWhere((s) =>
                    s.category.toLowerCase().contains(pattern.toLowerCase()));
                return filteredCategories;
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  leading: Icon(Icons.category),
                  title: Text(suggestion.category),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) {
                this._categoriesController.text = suggestion.category;
                _expenseRecord.category = suggestion;
              },
              validator: (value) {
                if (null == value || value.isEmpty) {
                  return "Please enter a category";
                }
                return null;
              },
              onSaved: (value) => setState(() {
                if (_expenseRecord.category == null) {
                  _expenseRecord.category = Category(category: value);
                }
              }),
            );
          }
        });
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(
              appBarTitle,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,)
          ),
          centerTitle: true,
        ),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 35.0),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    DateTimeField(
                      format: dateFormat,
                      decoration: InputDecoration(labelText: 'Expense Date'),
                      validator: (expenseDate) {
                        if (expenseDate == null) {
                          return "Please enter Expense Date";
                        }
                        return null;
                      },
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                      onSaved: (value) =>
                          setState(() => _expenseRecord.expenseDate = value),
                    ),
                    SizedBox(height: sizedBoxHeight),
                    _buildCategoriesDropDown(context),
                    SizedBox(height: sizedBoxHeight),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Description'),
                      onSaved: (value) {
                        _expenseRecord.description = value;
                      },
                    ),
                    SizedBox(height: sizedBoxHeight),
                    _buildPaymentModeDropDown(context),
                    SizedBox(height: sizedBoxHeight),
                    _buildPaymentBanksDropDown(),
                    SizedBox(height: sizedBoxHeight),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Amount'),
                      keyboardType: TextInputType.number,
                      validator: (category) {
                        if (category.isEmpty) {
                          return "Please enter a category";
                        }
                        return null;
                      },
                      onSaved: (value) => setState(
                          () => _expenseRecord.amount = double.parse(value)),
                    ),
                    SizedBox(height: sizedBoxHeight),
                    Row(
                      children: [
                        Expanded(
                            child: RaisedButton(
                                color: Theme.of(context).primaryColorDark,
                                textColor: Theme.of(context).primaryColorLight,
                                child: Text('Cancel',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  moveToLastScreen();
                                })),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                            child: RaisedButton(
                                color: Theme.of(context).primaryColorDark,
                                textColor: Theme.of(context).primaryColorLight,
                                child: Text(
                                  'Save',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  final form = _formKey.currentState;
                                  if (_formKey.currentState.validate()) {
                                    form.save();
                                    saveExpense(_expenseRecord);
                                  }
                                })),
                      ],
                    )
                  ],
                ),
            ),
          ),
      ),
    );
  }

  saveExpense(expenseRecord) async {
    int result = await DatabaseHelper.instance.saveExpense(_expenseRecord);
    if (result != 0) {
      moveToLastScreen();
    } else {
      _showAlertDialog("Failed", "Adding expense failed");
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}
