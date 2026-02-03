import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spring_autumn/Bloc/transactions/transaction__event.dart';
import 'package:spring_autumn/Bloc/transactions/transaction_state.dart';
import 'package:spring_autumn/Database/database_helper.dart';
class TransactionBloc
    extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionLoading()) {
    on<LoadTransactions>(_load);
    on<TransactionAdded>(_load);
    on<TransactionDeleted>(_load);
    on<TransactionUpdated>(_load);
  }

  Future<void> _load(
    TransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

    final transactions = await getAllTransactions();
    final categoryMap = await _loadCategoryMap();
    final balances = _calculateMethodBalances(transactions);

    emit(
      TransactionLoaded(
        transactions,
        categoryMap,
        cash: balances['cash']!,
        card: balances['card']!,
        upi: balances['upi']!,
      ),
    );
  }

  Future<Map<String, String>> _loadCategoryMap() async {
    final categories = await getAllCategories();
    return {
      for (final c in categories)
        c['id'] as String: c['name'] as String,
    };
  }

  Map<String, int> _calculateMethodBalances(
    List<Map<String, Object?>> data,
  ) {
    int cash = 0;
    int card = 0;
    int upi = 0;

    for (final tx in data) {
      final amount = tx['amount'] as int;
      final type = tx['type'] as String;
      final method = tx['method'] as String;

      final signedAmount =
          type == 'income' ? amount : -amount;

      switch (method) {
        case 'cash':
          cash += signedAmount;
          break;
        case 'card':
          card += signedAmount;
          break;
        case 'upi':
          upi += signedAmount;
          break;
      }
    }

    return {
      'cash': cash,
      'card': card,
      'upi': upi,
    };
  }
}
