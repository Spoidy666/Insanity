import 'package:flutter/material.dart';
import 'package:spring_autumn/Model/transaction_model.dart';
import 'package:spring_autumn/Widgets/edit_transaction_sheet.dart';

void showTransactionDetailsDialog(
  BuildContext context, {
  required TransactionModel transaction,
  required String categoryName,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return Dialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Transaction Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Divider(height: 24),

                        _detailRow("Title", transaction.title, context),
                        const Divider(thickness: 0.3),

                        _detailRow(
                          "Amount",
                          transaction.amount.toString(),
                          context,
                        ),
                        const Divider(thickness: 0.3),

                        _detailRow(
                          "Type",
                          _capitalize(transaction.type.name),
                          context,
                        ),
                        const Divider(thickness: 0.3),

                        _detailRow(
                          "Method",
                          _capitalize(transaction.method.name),
                          context,
                        ),
                        const Divider(thickness: 0.3),

                        _detailRow("Category", categoryName, context),
                        const Divider(thickness: 0.3),

                        if (transaction.notes != null)
                          _detailRow("Notes", transaction.notes!, context),

                        const Divider(thickness: 0.3),

                        _detailRow(
                          "Date",
                          DateTime.fromMillisecondsSinceEpoch(
                            transaction.transactionTimestamp,
                          ).toString().split(' ').first,
                          context,
                        ),
                        const Divider(thickness: 0.3),

                        _detailRow(
                          "Time",
                          DateTime.fromMillisecondsSinceEpoch(
                            transaction.createdAt,
                          ).toString(),
                          context,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);

                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            builder: (_) =>
                                EditTransactionSheet(transaction: transaction),
                          );
                        },
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Close",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _detailRow(String label, String value, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
  );
}

String _capitalize(String value) {
  return value[0].toUpperCase() + value.substring(1);
}
