enum Type { income, expense }

enum Method { upi, cash, card }

class TransactionModel {
  String id;
  String title;
  String categoryId;
  String? notes;
  int amount;
  Type type;
  Method method;

  int transactionTimestamp; // user-selected date/time
  int createdAt; // system time

  TransactionModel({
    required this.id,
    required this.title,
    required this.categoryId,
    this.notes,
    required this.amount,
    required this.type,
    required this.method,
    required this.transactionTimestamp,
    required this.createdAt,
  });

  DateTime get transactionDate =>
      DateTime.fromMillisecondsSinceEpoch(transactionTimestamp);
  TransactionModel copyWith({
    String? title,
    int? amount,
    String? notes,
    Type? type,
    Method? method,
    String? categoryId,
    int? transactionTimestamp,
  }) {
    return TransactionModel(
      id: id, 
      title: title ?? this.title,
      amount: amount ?? this.amount,
      notes: notes ?? this.notes,
      type: type ?? this.type,
      method: method ?? this.method,
      categoryId: categoryId ?? this.categoryId,
      transactionTimestamp: transactionTimestamp ?? this.transactionTimestamp,
      createdAt: createdAt, 
    );
  }
}

extension EnumDisplay on Enum {
  String get displayName {
    final s = name;
    return s[0].toUpperCase() + s.substring(1);
  }
}
