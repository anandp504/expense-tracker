import 'dart:async';
import 'dart:io' as io;

import 'package:expensesapp/com/anand/domain/expense_models.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class DatabaseHelper {
  static final _databaseName = "expenses.db";
  static final _databaseVersion = 1;

  final DateFormat dateFormat = DateFormat("dd-MMM-yy HH:mm");

  List<String> paymentModes = ["UPI", "CREDIT CARD", "CASH", "DEBIT CARD", "ACCOUNT DEBIT"];
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
    await db.execute('''CREATE TABLE payment_bank(id INTEGER PRIMARY KEY AUTOINCREMENT, bank TEXT NOT NULL)''');
    await db.execute('''CREATE TABLE payment_mode(id INTEGER PRIMARY KEY AUTOINCREMENT, mode TEXT NOT NULL)''');
    await db.execute('''CREATE TABLE category(id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT NOT NULL)''');

    await db.execute(
      '''CREATE TABLE expenses(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          expense_date INTEGER NOT NULL, 
          description TEXT, 
          category_id INTEGET NOT NULL,
          payment_bank_id INTEGER NOT NULL, 
          payment_mode_id INTEGER NOT NULL, 
          amount REAL NOT NULL,
          FOREIGN KEY (payment_bank_id) REFERENCES payment_bank (id),
          FOREIGN KEY (payment_mode_id) REFERENCES payment_mode (id),
          FOREIGN KEY (category_id) REFERENCES category (id)
          )''');

    Batch banksDbBatch = db.batch();
    var banks = _createInsertRecords("bank", paymentBanks);
    for(int i = 0; i < banks.length; i++) {
      banksDbBatch.insert("payment_bank", banks[i]);
    }
    await banksDbBatch.commit(noResult: true);

    Batch modesDbBatch = db.batch();
    var modes = _createInsertRecords("mode", paymentModes);
    for(int i = 0; i < modes.length; i++) {
      modesDbBatch.insert("payment_mode", modes[i]);
    }
    await modesDbBatch.commit(noResult: true);

  }

  List<Map<String, String>> _createInsertRecords(String columnName, List<String> inputValues) {
    var rows = List<Map<String, String>>();
    for(int i = 0; i < inputValues.length; i++) {
      rows.add(Map.from({"$columnName": "${inputValues[i]}"}));
    }
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
    List<Map> dbRecords = await dbClient.rawQuery("SELECT id, mode FROM payment_mode");
    List<PaymentMode> paymentModes = new List();
    for(int i = 0; i < dbRecords.length; i++) {
      var mode = PaymentMode(id: dbRecords[i]["id"], mode: dbRecords[i]["mode"]);
      paymentModes.add(mode);
    }
    return paymentModes;
  }

  Future<List<Category>> getCategories() async {
    var dbClient = await instance.database;
    List<Map> dbRecords = await dbClient.rawQuery("SELECT id, category FROM category");
    List<Category> categories = new List();
    for(int i = 0; i < dbRecords.length; i++) {
      var category = Category(id: dbRecords[i]["id"], category: dbRecords[i]["category"]);
      categories.add(category);
    }
    return categories;
  }

  Future<int> saveExpense(Expense expense) async {
    var dbClient = await instance.database;
    var record = Map<String, dynamic>();
    if (null == expense.category.id) {
      int categoryId = await dbClient.insert("category", Map.from({"category": "${expense.category.category}" }));
      record.putIfAbsent("category_id", () => categoryId);
    } else {
      record.putIfAbsent("category_id", () => expense.category.id);
    }

    record.putIfAbsent("expense_date", () => expense.expenseDate.millisecondsSinceEpoch);
    if (expense.description != null) record.putIfAbsent("description", () => expense.description);
    record.putIfAbsent("payment_bank_id", () => expense.paymentBank.id);
    record.putIfAbsent("payment_mode_id", () => expense.paymentMode.id);
    record.putIfAbsent("amount", () => expense.amount);
    return dbClient.insert("expenses", record);
  }

  Future<List<Expense>> getExpenses() async {
    var dbClient = await instance.database;
    List<Map> dbRecords = new List();
    try {
      dbRecords = await dbClient.rawQuery(
          "SELECT exp.id AS expense_id, exp.expense_date, exp.description, exp.category_id, cat.category, exp.payment_bank_id, pb.bank AS payment_bank, "
              "exp.payment_mode_id, pm.mode AS payment_mode, exp.amount "
              "FROM expenses AS exp, payment_bank AS pb, payment_mode AS pm, category cat "
              "WHERE exp.category_id = cat.id AND exp.payment_bank_id = pb.id "
              "AND exp.payment_mode_id = pm.id ORDER BY exp.expense_date DESC;");
    } on Exception catch (ex) {
      print(ex.toString());
    } catch (error) {
      print(error);
    }
    return _transformDbDataToModel(dbRecords);
  }

  Future<List<Expense>> getExpensesWithOffset(int limit, int offset) async {
    var dbClient = await instance.database;
    List<Map> dbRecords = new List();
    try {
      dbRecords = await dbClient.rawQuery(
          "SELECT exp.id AS expense_id, exp.expense_date, exp.description, exp.category_id, cat.category, exp.payment_bank_id, pb.bank AS payment_bank, "
              "exp.payment_mode_id, pm.mode AS payment_mode, exp.amount "
              "FROM expenses AS exp, payment_bank AS pb, payment_mode AS pm, category cat "
              "WHERE exp.category_id = cat.id AND exp.payment_bank_id = pb.id "
              "AND exp.payment_mode_id = pm.id ORDER BY exp.expense_date DESC LIMIT $limit OFFSET $offset;");
    } on Exception catch (ex) {
      print(ex.toString());
    } catch (error) {
      print(error);
    }
    return _transformDbDataToModel(dbRecords);;
  }

  Future<int> getExpenseRecordCount() async {
    var dbClient = await instance.database;
    List<Map> dbRecords = new List();
    try {
      dbRecords = await dbClient.rawQuery("SELECT COUNT(1) AS expenses_count FROM expenses;");
    } on Exception catch (ex) {
      print(ex.toString());
    } catch (error) {
      print(error);
    }

    int expensesRecordCount = 0;
    for(int i = 0; i < dbRecords.length; i++) {
      expensesRecordCount = dbRecords[i]["expenses_count"];
    }
    return expensesRecordCount;
  }

  Future<List<AggregateResult>> getCategoriesAggregation() async {
    String categoriesQuery = "SELECT cat.category, SUM(exp.amount) AS amount "
        "FROM expenses AS exp, category cat "
        "WHERE exp.category_id = cat.id "
        "GROUP BY cat.category ORDER BY SUM(exp.amount) DESC LIMIT 5 ;";

    return _getAggregationResult(categoriesQuery, "category");
  }

  Future<List<AggregateResult>> getPaymentModeAggregation() async {
    String categoriesQuery = "SELECT pm.mode, SUM(exp.amount) AS amount "
        "FROM expenses AS exp, payment_mode AS pm "
        "WHERE exp.payment_mode_id = pm.id "
        "GROUP BY pm.mode ORDER BY SUM(exp.amount) DESC;";

    return _getAggregationResult(categoriesQuery, "mode");
  }

  _transformDbDataToModel(List<Map> dbRecords) {
    List<Expense> expenseRecords = new List();

    for(int i = 0; i < dbRecords.length; i++) {
      var expense = new Expense.c1(
          id: dbRecords[i]["expense_id"],
          expenseDate: new DateTime.fromMillisecondsSinceEpoch(dbRecords[i]["expense_date"]),
          description: dbRecords[i]["description"],
          category: Category(id: dbRecords[i]["category_id"], category: dbRecords[i]["category"]),
          paymentBank: PaymentBank(id: dbRecords[i]["payment_bank_id"], bank: dbRecords[i]["payment_bank"]),
          paymentMode: PaymentMode(id: dbRecords[i]["payment_mode_id"], mode: dbRecords[i]["payment_mode"]),
          amount: dbRecords[i]["amount"]
      );
      expenseRecords.add(expense);
    }
    return expenseRecords;
  }

  Future<List<AggregateResult>> _getAggregationResult(String query, String dimension) async {

    var dbClient = await instance.database;
    List<AggregateResult> aggResult = new List();
    List<Map> dbRecords = new List();

    try {
      dbRecords = await dbClient.rawQuery(query);
    } on Exception catch (ex) {
      print(ex.toString());
    } catch (error) {
      print(error);
    }

    for(int i = 0; i < dbRecords.length; i++) {
      var aggregation = new AggregateResult(
          dimension: dbRecords[i][dimension],
          amount: dbRecords[i]["amount"]
      );
      aggResult.add(aggregation);
    }
    return aggResult;
  }

  Future<int> deleteExpense(int expenseId) async {
    var dbClient = await instance.database;
    return await dbClient.delete("expenses", where: "id = ?", whereArgs: [expenseId]);
  }
}