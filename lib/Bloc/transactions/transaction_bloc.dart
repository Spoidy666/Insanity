import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spring_autumn/Bloc/transactions/transaction__event.dart';
import 'package:spring_autumn/Bloc/transactions/transaction_state.dart';
import 'package:spring_autumn/Database/database_helper.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  int _calculateBalance(List<Map<String, Object?>> data) {
    int balance = 0;

    for (final tx in data) {
      final amount = tx['amount'] as int;
      final type = tx['type'] as String;

      if (type == 'income') {
        balance += amount;
      } else {
        balance -= amount;
      }
    }

    return balance;
  }

  Future<Map<String, String>> _loadCategoryMap() async {
    final categories = await getAllCategories();

    return {for (final c in categories) c['id'] as String: c['name'] as String};
  }

  TransactionBloc() : super(TransactionLoading()) {
    on<LoadTransactions>((event, emit) async {
      emit(TransactionLoading());

      final transactions = await getAllTransactions();
      final categoryMap = await _loadCategoryMap();
      final balance = _calculateBalance(transactions);

      emit(TransactionLoaded(transactions, categoryMap, balance));
    });

    on<TransactionAdded>((event, emit) async {
      final transactions = await getAllTransactions();
      final categoryMap = await _loadCategoryMap();
      final balance = _calculateBalance(transactions);

      emit(TransactionLoaded(transactions, categoryMap, balance));
    });
    on<TransactionDeleted>((event, emit) async {
      final transactions = await getAllTransactions();
      final categoryMap = await _loadCategoryMap();
      final balance = _calculateBalance(transactions);

      emit(TransactionLoaded(transactions, categoryMap, balance));
    });
    on<TransactionUpdated>((event, emit) async {
  final transactions = await getAllTransactions();
  final categoryMap = await _loadCategoryMap();
  final balance = _calculateBalance(transactions);

  emit(TransactionLoaded(transactions, categoryMap, balance));
});

  }
}
