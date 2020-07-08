import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:dropdown_search/dropdown_search.dart';
// import 'package:search_widget/search_widget.dart';

import 'package:expensesapp/com/anand/domain/expenses.dart';
import 'package:expensesapp/com/anand/db/db_helper.dart';
import 'package:expensesapp/com/anand/screens/search/searchable_category.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class ExpenseDetail extends StatefulWidget {

  final String appBarTitle;

  ExpenseDetail({ this.appBarTitle });

  @override
  _ExpenseDetailState createState() => _ExpenseDetailState(appBarTitle: this.appBarTitle);
}

class _ExpenseDetailState extends State<ExpenseDetail> {

  String appBarTitle;

  _ExpenseDetailState({ this.appBarTitle });

  var _formKey = GlobalKey<FormState>();
  // var _categorySearchKey = GlobalKey<AutoCompleteTextFieldState<Category>>();
  final dateFormat = DateFormat("dd-MMM-yyyy");

  Future<List<PaymentMode>> modes;
  Future<List<PaymentBank>> banks;
  Future<List<Category>> categories;
  DateTime date;

  ExpenseRecord _expenseRecord = ExpenseRecord();
  final TextEditingController _controller = new TextEditingController();
  var items = ['Working a lot harder', 'Being a lot smarter', 'Being a self-starter', 'Placed in charge of trading charter'];
  AutoCompleteTextField<Category> categorySearchTextField;

  @override
  void initState() {
    categories = DatabaseHelper.instance.getCategories();
    modes = DatabaseHelper.instance.getPaymentModes();
    banks = DatabaseHelper.instance.getBanks();
    super.initState();
  }

  /*
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
              return DropdownSearch<PaymentMode>(
                items: snapshot.data,
                itemAsString: (PaymentMode m) => m.mode,
                showSearchBox: true,
                showClearButton: true,
                label: "Payment Mode",
                validator: (PaymentMode item) {
                  if (item == null)
                    return "Please enter a payment mode";
                  else
                    return null;
                },
                onSaved: (value) => setState( () => _expenseRecord.paymentMode = value),
              );
            default:
              return Text('No PaymentMode data found', style: TextStyle(color: Colors.grey[600]),);
          }
        }
    );
  }

  Widget _buildBanksDropDown(BuildContext context) {
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
              return DropdownSearch<PaymentBank>(
                items: snapshot.data,
                itemAsString: (PaymentBank b) => b.bank,
                showSearchBox: true,
                showClearButton: true,
                label: "Payment Bank",
                validator: (PaymentBank item) {
                  if (item == null)
                    return "Please enter a payment bank";
                  else
                    return null;
                },
                onSaved: (value) => setState( () => _expenseRecord.paymentBank = value),
              );
            default:
              return Text('No PaymentBank data found', style: TextStyle(color: Colors.grey[600]),);
          }
        }
    );
  }
  */

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
              // _expenseRecord.paymentBank = bankData[0];
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
                hint: "Payment Bank",
                searchHint: "Select Bank",
                label: "Payment Bank",
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
                hint: "Payment Mode",
                searchHint: "Select Mode",
                label: "Payment Mode",
                onChanged: (value) { setState(() {
                  _expenseRecord.paymentMode = value; });
                },
                isExpanded: true,
                validator: (PaymentMode item) {
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

  Widget _buildCategorySearchResult(Category category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(category.category),
      ],
    );
  }

  /*
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
              List<Category> modeData = snapshot.data;
              categorySearchTextField = AutoCompleteTextField<Category>(
                key: _categorySearchKey,
                suggestions: modeData,
                clearOnSubmit: false,
                decoration: InputDecoration(
                  hintText: "Search Payment Mode",
                ),
                itemFilter: (item, query) {
                  return item.category.toLowerCase().contains(query.toLowerCase());
                },
                itemSorter: (a, b) {
                  return a.category.compareTo(b.category);
                },
                itemBuilder: (context, item) {
                  return _buildCategorySearchResult(item);
                },
                itemSubmitted: (item) {
                  setState(() {
                    categorySearchTextField.textField.controller.text = item.category;
                    _expenseRecord.category = item;
                  });
                },
              );
              return categorySearchTextField;
            default:
              return Text('No PaymentMode data found', style: TextStyle(color: Colors.grey[600]),);
          }
        }
    );
  }
  */

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
                    controller: this._controller,
                    decoration: InputDecoration(
                        labelText: 'Category'
                    )
                ),
                suggestionsCallback: (pattern) {
                  List<Category> filteredCategories = new List();
                  filteredCategories.addAll(categoriesList);
                  filteredCategories.retainWhere((s) => s.category.toLowerCase().contains(pattern.toLowerCase()));
                  return filteredCategories;
                },
                itemBuilder: (context, suggestion) {
                  return _buildCategorySearchResult(suggestion);
                },
                transitionBuilder: (context, suggestionsBox, controller) {
                  return suggestionsBox;
                },
                onSuggestionSelected: (suggestion) {
                  this._controller.text = suggestion.category;
                },
                validator: (value) {
                  if (null == value) {
                    return "Please enter a category";
                  }
                  return null;
                },
                onSaved: (value) => setState(() {
                  print("Entered category = $value");
                  Category result = categoriesList.firstWhere((s) => s.category.toLowerCase() == value, orElse: () => null);
                  if (null == result) {
                    _expenseRecord.category = Category(category: value);
                  } else {
                    _expenseRecord.category = result;
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
        // backgroundColor: Colors.grey[900],
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(
              appBarTitle,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontFamily: "RopaSans-Regular",)
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent[600],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Column(
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
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                        },
                        onSaved: (value) => setState( () => _expenseRecord.expenseDate = value), //dateFormat.format(value)),
                      ),
                      SizedBox(height: 15.0),
                      _buildCategoriesDropDown(context),
                      SizedBox(height: 15.0),
                      // _buildPaymentModeDropDown(context),
                      _buildPaymentModeDropDown(context),
                      SizedBox(height: 15.0),
                      // _buildBanksDropDown(context),
                      _buildPaymentBanksDropDown(),
                      SizedBox(height: 15.0),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Amount'),
                        keyboardType: TextInputType.number,
                        validator: (category) {
                          if(category.isEmpty) {
                            return "Please enter a category";
                          }
                          return null;
                        },
                        onSaved: (value) => setState( () => _expenseRecord.amount = double.parse(value)),
                      ),
                      SizedBox(height: 15.0),
                      Container(
                        child: RaisedButton(
                          child: Text("Save"),
                          onPressed: () {
                            final form = _formKey.currentState;
                            if (_formKey.currentState.validate()) {
                              // _formKey.currentState.save();
                              form.save();
                              saveExpense(_expenseRecord);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
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
      print("Do nothing");
    }
  }

}
