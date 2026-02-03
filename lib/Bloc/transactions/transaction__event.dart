abstract class TransactionEvent {}

class LoadTransactions extends TransactionEvent {}

class TransactionAdded extends TransactionEvent {}

class TransactionDeleted extends TransactionEvent {}

class TransactionUpdated extends TransactionEvent {}
