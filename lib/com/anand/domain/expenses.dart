
class ExpenseRecord {
  DateTime expenseDate;
  String description;
  // String category;
  // String paymentBank;
  // String paymentMode;
  Category category;
  PaymentBank paymentBank;
  PaymentMode paymentMode;
  double amount;

  ExpenseRecord();
  // ExpenseRecord.c1({ this.expenseDate, this. description, this. amount, this.category, this.paymentBank, this.paymentMode });
  ExpenseRecord.c1({ this.expenseDate, this. description, this. amount, this.category, this.paymentBank, this.paymentMode });
  // ExpenseRecord.c2({this.expenseDate, this.category, this.paymentBank, this.paymentMode});
  ExpenseRecord.c2({ this.expenseDate, this.category, this.paymentBank, this.paymentMode });

}

class Category {
  int id;
  String category;

  Category({ this.id, this.category });
  Category.c1({ this.category });
}

class PaymentBank {
  int id;
  String bank;

  PaymentBank({ this.id, this.bank });

  @override
  String toString() {
    return this.bank;
  }
}

class PaymentMode {
  int id;
  String mode;

  PaymentMode({ this.id, this.mode });

  @override
  String toString() {
    return this.mode;
  }
}