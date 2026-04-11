import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spring_autumn/Bloc/currency/currency_cubit.dart';
import 'package:spring_autumn/Model/transaction_model.dart';
import 'package:spring_autumn/Widgets/Custom/custom_bold_text.dart';
import 'package:spring_autumn/Widgets/Transaction/transaction_details_dialog.dart';

class TransactionTile extends StatelessWidget {
  final Map<String, Object?> transaction;
  final String categoryName;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final amount = (transaction['amount'] as num).toDouble();
    final isExpense = transaction['type'] == 'expense';

    return BlocBuilder<CurrencyCubit, AppCurrency>(
      builder: (context, currency) {
        final formatter = NumberFormat.currency(
          locale: currency.locale,
          symbol: '',
          decimalDigits: currency.decimalDigits,
        );

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          color: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: CustomBoldText(
              text: transaction['title'] as String,
              size: 17,
            ),
            subtitle: Text(
              "${_formatTime(transaction['transaction_timestamp'] as int)}   ${_formatMethod(transaction['method'] as String)}",
            ),
            trailing: Text(
              formatter.format(amount),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: isExpense ? Colors.red : Colors.green,
              ),
            ),
            onTap: () {
              final tx = TransactionModel(
                id: transaction['id'] as String,
                title: transaction['title'] as String,
                categoryId: transaction['category_id'] as String,
                notes: transaction['notes'] as String?,
                amount: amount,
                type: Type.values.byName(transaction['type'] as String),
                method: Method.values.byName(transaction['method'] as String),
                transactionTimestamp:
                    transaction['transaction_timestamp'] as int,
                createdAt: transaction['created_at'] as int,
              );

              showTransactionDetailsDialog(
                context,
                transaction: tx,
                categoryName: categoryName,
              );
            },
          ),
        );
      },
    );
  }

  String _formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatMethod(String method) {
    return method[0].toUpperCase() + method.substring(1);
  }
}
