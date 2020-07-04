import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:expensesapp/com/anand/domain/expenses.dart';
// import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:expensesapp/com/anand/db/db_helper.dart';

class ExpenseForm extends StatefulWidget {
  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {

  var _formKey = GlobalKey<FormState>();
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  final dateFormat = DateFormat("dd-MMM-yyyy");

  Future<List<PaymentMode>> modes;
  Future<List<PaymentBank>> banks;
  DateTime date;
  ExpenseRecord _expenseRecord = ExpenseRecord();
  List<String> paymentModes = ["UPI", "CREDIT CARD", "DEBIT CARD", "NEFT", "IMPS"];
  List<String> paymentBanks = ["CITIBANK", "ICICI", "HDFC", "SBI", "CANARA BANK", "IOB"];


  @override
  void initState() {
    super.initState();
    modes = dbHelper.getPaymentModes();
    banks = dbHelper.getBanks();
  }

  _buildPaymentModeDropDown(BuildContext context) {
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
                // items: snapshot.data,
                itemAsString: (PaymentMode m) => m.mode,
                label: "Payment Mode",
                // onChanged: print,
                // onFind: (String filter) => ,
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

  _buildBanksDropDown(BuildContext context) {
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
                // items: snapshot.data,
                itemAsString: (PaymentBank b) => b.bank,
                label: "Payment Bank",
                // onChanged: print,
                // onFind: (String filter) => ,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
            "Expense Form",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, letterSpacing: 2.0, fontFamily: "RopaSans-Regular",)
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent[600],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Form(
            key: _formKey,
            child: Column(
                children: <Widget>[
                  // TextField(decoration: InputDecoration(hintText: 'Date'),),
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
                    onSaved: (value) => setState( () => _expenseRecord.expenseDate = dateFormat.format(value)),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(decoration: InputDecoration(labelText: 'Category'),
                  keyboardType: TextInputType.text,
                  validator: (category) {
                    if(category.isEmpty) {
                      return "Please enter a category";
                    }
                    return null;
                  },
                  onSaved: (value) => setState( () => _expenseRecord.category = value),
                  ),
                  SizedBox(height: 10.0),
                  DropdownSearch(
                    items: paymentModes,
                    label: "Payment Mode",
                    onChanged: print,
                    selectedItem: "UPI",
                    validator: (String item) {
                      if (item == null)
                        return "Please enter a payment mode";
                      else
                        return null;
                    },
                    onSaved: (value) => setState( () => _expenseRecord.paymentMode = value),
                  ),
                  SizedBox(height: 10.0),
                  DropdownSearch(
                    items: paymentBanks,
                    label: "Payment Bank",
                    onChanged: print,
                    selectedItem: "ICICI",
                    validator: (String item) {
                      if (item == null)
                        return "Please enter a payment bank";
                      else
                        return null;
                    },
                    onSaved: (value) => setState( () => _expenseRecord.paymentBank = value),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (category) {
                    if(category.isEmpty) {
                      return "Please enter a category";
                    }
                    return null;
                  },
                  onSaved: (value) => setState( () => _expenseRecord.amount = double.parse(value)),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    child: RaisedButton(
                      child: Text("Save"),
                      onPressed: () {
                        final form = _formKey.currentState;
                        if (_formKey.currentState.validate()) {
                          // _formKey.currentState.save();
                          form.save();
                          dbHelper.saveExpense(_expenseRecord);
                          Navigator.of(context).pushNamed("/");
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
      ),
      );
  }

}
