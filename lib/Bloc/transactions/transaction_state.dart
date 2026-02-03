abstract class TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Map<String, Object?>> transactions;
  final Map<String, String> categoryMap;
  final int cash, card, upi;

  TransactionLoaded(this.transactions, this.categoryMap, {required this.cash, required this.card, required this.upi} );
}
