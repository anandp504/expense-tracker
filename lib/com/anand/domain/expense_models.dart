
class Expense {
  int id;
  DateTime expenseDate;
  String description;
  Category category;
  PaymentBank paymentBank;
  PaymentMode paymentMode;
  double amount;

  Expense();
  Expense.c1({ this.id, this.expenseDate, this. description, this. amount, this.category, this.paymentBank, this.paymentMode });
  Expense.c2({ this.expenseDate, this.category, this.paymentBank, this.paymentMode });

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

class AggregateResult {
  String dimension;
  double amount;

  AggregateResult({this.dimension, this.amount});
}