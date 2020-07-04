import 'dart:async';
import 'dart:io' as io;

import 'package:expensesapp/com/anand/domain/expenses.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class DatabaseHelper {
  static final _databaseName = "expenses.db";
  static final _databaseVersion = 1;

  final DateFormat dateFormat = DateFormat("dd-MMM-yyyy");

  List<String> paymentModes = ["UPI", "CREDIT CARD", "DEBIT CARD", "NEFT", "IMPS", "ECS"];
  List<String> paymentBanks = ["Bank of Baroda", "Bank of India", "Bank of Maharashtra", "Canara Bank",
    "Central Bank of India", "Citibank", "Indian Bank", "Indian Overseas Bank", "Punjab and Sind Bank", "Punjab National Bank",
    "State Bank of India", "UCO Bank", "Union Bank of India", "Axis Bank", "Bandhan Bank", "Catholic Syrian Bank",
    "City Union Bank", "DCB Bank", "Dhanlaxmi Bank", "Federal Bank", "HDFC Bank", "ICICI Bank", "IDBI Bank", "IDFC First Bank",
    "IndusInd Bank", "Jammu & Kashmir Bank", "Karnataka Bank", "Karur Vysya Bank", "Kotak Mahindra Bank", "Lakshmi Vilas Bank",
    "Nainital Bank", "RBL Bank", "South Indian Bank", "Tamilnad Mercantile Bank", "Yes Bank"];

// make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

// only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

// this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

// SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute(
      '''CREATE TABLE expenses(
          expense_date INTEGER NOT NULL, 
          description TEXT, 
          category TEXT NOT NULL, 
          payment_bank TEXT NOT NULL, 
          payment_mode TEXT NOT NULL, 
          amount REAL NOT NULL)''');

    await db.execute('''CREATE TABLE payment_bank(id INTEGER PRIMARY KEY AUTOINCREMENT, bank TEXT NOT NULL)''');

    await db.execute('''CREATE TABLE payment_mode(id INTEGER PRIMARY KEY AUTOINCREMENT, mode TEXT NOT NULL)''');

    Batch dbBatch = db.batch();
    var banks = _createInsertRecords(paymentBanks);
    banks.map((bank) => dbBatch.insert("payment_bank", bank));
    await dbBatch.commit(noResult: true);

    var modes = _createInsertRecords(paymentModes);
    modes.map((mode) => dbBatch.insert("payment_mode", mode));
    await dbBatch.commit(noResult: true);

  }

  List<Map<String, String>> _createInsertRecords(List<String> inputValues) {
    var rows = List<Map<String, String>>();
    inputValues.map(
      (input) => rows.add(Map.from({"bank": input}))
    );
    return rows;
  }

  Future<List<PaymentBank>> getBanks() async {
    var dbClient = await instance.database;
    List<Map> dbRecords = await dbClient.rawQuery("SELECT id, bank FROM payment_bank");
    List<PaymentBank> banks = new List();
    for(int i = 0; i < dbRecords.length; i++) {
      var bank = PaymentBank(id: dbRecords[i]["id"], bank: dbRecords[i]["bank"]);
      banks.add(bank);
    }
    return banks;
  }

  Future<List<PaymentMode>> getPaymentModes() async {
    var dbClient = await instance.database;
    List<Map> dbRecords = await dbClient.rawQuery("SELECT id, bank FROM payment_mode");
    List<PaymentMode> paymentModes = new List();
    for(int i = 0; i < dbRecords.length; i++) {
      var mode = PaymentMode(id: dbRecords[i]["id"], mode: dbRecords[i]["mode"]);
      paymentModes.add(mode);
    }
    return paymentModes;
  }

  Future<int> saveExpense(ExpenseRecord expense) async {
    var dbClient = await instance.database;
    var record = Map<String, dynamic>();
    record.putIfAbsent("expense_date", () => dateFormat.parse(expense.expenseDate).millisecondsSinceEpoch);
    if (expense.description != null) record.putIfAbsent("description", () => expense.description);
    record.putIfAbsent("category", () => expense.category);
    record.putIfAbsent("payment_bank", () => expense.paymentBank);
    record.putIfAbsent("payment_mode", () => expense.paymentMode);
    record.putIfAbsent("amount", () => expense.amount);
    int result = await dbClient.insert("expenses", record);
    return result;
  }

  Future<List<ExpenseRecord>> getExpenses() async {
    var dbClient = await instance.database;
    List<Map> dbRecords = await dbClient.rawQuery("SELECT * FROM expenses");
    List<ExpenseRecord> expenseRecords = new List();
    for(int i = 0; i < dbRecords.length; i++) {
      var expense = new ExpenseRecord.c1(
        expenseDate: DateFormat.yMd().format(new DateTime.fromMillisecondsSinceEpoch(dbRecords[i]["expense_date"])),
        description: dbRecords[i]["description"],
        category: dbRecords[i]["category"],
        paymentBank: dbRecords[i]["payment_bank"],
        paymentMode: dbRecords[i]["payment_mode"],
        amount: dbRecords[i]["amount"]
      );
      expenseRecords.add(expense);
    }
    expenseRecords.map((exp) => print("${exp.expenseDate} | ${exp.category} | ${exp.paymentBank}"));
    return expenseRecords;
  }

}