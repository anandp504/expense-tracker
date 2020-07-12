import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
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

  Future<List<PaymentMode>> modes;
  Future<List<PaymentBank>> banks;
  Future<List<Category>> categories;
  DateTime date;

  Expense _expenseRecord = Expense();
  final TextEditingController _categoriesController = new TextEditingController();

  @override
  void initState() {
    categories = DatabaseHelper.instance.getCategories();
    modes = DatabaseHelper.instance.getPaymentModes();
    banks = DatabaseHelper.instance.getBanks();
    super.initState();
  }

  Widget _buildPaymentBanksDropDown() {
    return FutureBuilder<List<PaymentBank>>(
        future: banks,
        builder: (BuildContext context,
            AsyncSnapshot<List<PaymentBank>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('No PaymentBank data found', style: TextStyle(color: Colors.grey[600]),);
            case ConnectionState.waiting:
              return Text('Loading PaymentBank data', style: TextStyle(color: Colors.grey[600]),);
            case ConnectionState.done:
              List<DropdownMenuItem<PaymentBank>> bankDropDown = new List();
              List<PaymentBank> bankData = snapshot.data;
              for(int i = 0; i < bankData.length; i++) {
                bankDropDown.add(
                  DropdownMenuItem(
                    child: Text(bankData[i].bank),
                    value: bankData[i],
                  )
                );
              }
              return SearchableDropdown.single(
                items: bankDropDown,
                value: _expenseRecord.paymentBank,
                // searchHint: "Search for a Bank",
                label: "Payment Bank",
                // style: DefaultTextStyle.of(context).style,
                onChanged: (value) { setState(() {
                  _expenseRecord.paymentBank = value; });
                },
                isExpanded: true,
                validator: (PaymentBank item) {
                  if (item == null)
                    return "Please enter a payment bank";
                  else
                    return null;
                },
              );
            default:
              return Text('No PaymentBank data found', style: TextStyle(color: Colors.grey[600]),);
          }
        }
    );
  }

  Widget _buildPaymentModeDropDown(BuildContext context) {
    return FutureBuilder<List<PaymentMode>>(
        future: modes,
        builder: (BuildContext context,
            AsyncSnapshot<List<PaymentMode>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('No PaymentMode data found', style: TextStyle(color: Colors.grey[600]),);
            case ConnectionState.waiting:
              return Text('Loading PaymentMode data', style: TextStyle(color: Colors.grey[600]),);
            case ConnectionState.done:
              List<DropdownMenuItem<PaymentMode>> paymentModeDropDown = new List();
              List<PaymentMode> modeData = snapshot.data;
              for(int i = 0; i < modeData.length; i++) {
                paymentModeDropDown.add(
                    DropdownMenuItem(
                      child: Text(modeData[i].mode),
                      value: modeData[i],
                    )
                );
              }
              return SearchableDropdown.single(
                items: paymentModeDropDown,
                value: _expenseRecord.paymentMode,
                // searchHint: "Search for a Payment Mode",
                label: "Payment Mode",
                // style: DefaultTextStyle.of(context).style,
                onChanged: (item) { setState(() {
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
            default:
              return Text('No PaymentMode data found', style: TextStyle(color: Colors.grey[600]),);
          }
        }
    );
  }


  _buildCategoriesDropDown(BuildContext context) {
    return FutureBuilder<List<Category>>(
        future: categories,
        builder: (BuildContext context,
            AsyncSnapshot<List<Category>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('No PaymentMode data found', style: TextStyle(color: Colors.grey[600]),);
            case ConnectionState.waiting:
              return Text('Loading PaymentMode data', style: TextStyle(color: Colors.grey[600]),);
            case ConnectionState.done:
              List<Category> categoriesList = snapshot.data;
              return TypeAheadFormField<Category>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: _categoriesController,
                  // style: DefaultTextStyle.of(context).style,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Category'),
                ),
                suggestionsCallback: (pattern) {
                  List<Category> filteredCategories = new List();
                  filteredCategories.addAll(categoriesList);
                  filteredCategories.retainWhere((s) => s.category.toLowerCase().contains(pattern.toLowerCase()));
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
                  if (null == value) {
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
            default:
              return Text('No PaymentMode data found', style: TextStyle(color: Colors.grey[600]),);
          }
        }
    );
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
