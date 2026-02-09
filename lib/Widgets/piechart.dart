import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spring_autumn/Bloc/currency/currency_cubit.dart';
import 'package:spring_autumn/Bloc/transactions/transaction_bloc.dart';
import 'package:spring_autumn/Bloc/transactions/transaction_state.dart';
import 'package:spring_autumn/Model/transaction_model.dart';

class ExpensePieChartCard extends StatelessWidget {
  final Type type;
  final DateTime? month;
  const ExpensePieChartCard({
    super.key,
    required this.type,
    required this.month,
  });
  Map<String, double> _buildExpenseData(
    List<Map<String, Object?>> transactions,
    Map<String, String> categoryMap,
  ) {
    final Map<String, double> data = {};

    for (final tx in transactions) {
      if (tx['type'] != type.name) continue;
      final txDate = DateTime.fromMillisecondsSinceEpoch(
        tx['transaction_timestamp'] as int,
      );

      if (month != null) {
        if (txDate.year != month!.year || txDate.month != month!.month) {
          continue;
        }
      }

      final categoryId = tx['category_id'] as String;
      final categoryName = categoryMap[categoryId] ?? 'Unknown';
      final amount = (tx['amount'] as num).toDouble();

      data[categoryName] = (data[categoryName] ?? 0) + amount;
    }

    return data;
  }

  Color _generateColor(int index, int total) {
    final hue = (360.0 / total) * index;

    return HSVColor.fromAHSV(
      1.0, // alpha
      hue, // hue
      0.65, // saturation
      0.85,
    ).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is! TransactionLoaded) {
          return const SizedBox.shrink();
        }

        final data = _buildExpenseData(state.transactions, state.categoryMap);

        if (data.isEmpty) {
          return const SizedBox.shrink();
        }

        final keys = data.keys.toList();
        final totalAmount = data.values.reduce((a, b) => a + b);

        final Map<String, Color> colorMap = {};
        for (int i = 0; i < keys.length; i++) {
          colorMap[keys[i]] = _generateColor(i, keys.length);
        }

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Chart",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),

              const SizedBox(height: 26),
              SizedBox(
                height: 160,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 5,
                    centerSpaceRadius: 60,
                    sections: data.entries.map((entry) {
                      final color = colorMap[entry.key]!;

                      return PieChartSectionData(
                        value: entry.value,
                        color: color,
                        radius: 35,
                        title:
                            "${((entry.value / totalAmount) * 100).toStringAsFixed(1)}%",
                        titleStyle: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              BlocBuilder<CurrencyCubit, AppCurrency>(
                builder: (context, currency) {
                  return Column(
                    children: data.entries.map((e) {
                      final color = colorMap[e.key]!;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(e.key)),
                            Text(
                              NumberFormat.currency(
                                locale: currency.locale,
                                symbol: currency.symbol,
                                decimalDigits: currency.decimalDigits,
                              ).format(e.value),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
