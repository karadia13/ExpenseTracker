class Expense {
  String category;
  double amount;
  String description;
  DateTime date;

  Expense({
    String category,
    double amount,
    String description,
    DateTime date,
  })  : category = category,
        amount = amount,
        description = description,
        date = date;
}
