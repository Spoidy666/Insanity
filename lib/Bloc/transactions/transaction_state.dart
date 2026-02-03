abstract class TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Map<String, Object?>> transactions;
  final Map<String, String> categoryMap; 
  final int balance;

  TransactionLoaded(this.transactions, this.categoryMap, this.balance);
}
