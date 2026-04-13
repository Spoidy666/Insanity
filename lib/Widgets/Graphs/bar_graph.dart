import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spring_autumn/Bloc/transactions/transaction_bloc.dart';
import 'package:spring_autumn/Bloc/transactions/transaction_state.dart';
import 'package:spring_autumn/Model/transaction_model.dart';

class ExpenseBarChartCard extends StatelessWidget {
  final Type type;
  final DateFilter? dateFilter;

  const ExpenseBarChartCard({
    super.key,
    required this.type,
    required this.dateFilter,
  });

  Map<String, double> _buildExpenseData(
    List<Map<String, Object?>> transactions,
    Map<String, String> categoryMap,
  ) {
    final Map<String, double> data = {};

    for (final tx in transactions) {
      if (tx['type'] != type.name) continue;

      if (dateFilter != null) {
        final txDate = DateTime.fromMillisecondsSinceEpoch(
          tx['transaction_timestamp'] as int,
        );

        if (dateFilter!.mode == DateFilterMode.month) {
          if (txDate.year != dateFilter!.date.year ||
              txDate.month != dateFilter!.date.month) {
            continue;
          }
        } else {
          if (txDate.year != dateFilter!.date.year ||
              txDate.month != dateFilter!.date.month ||
              txDate.day != dateFilter!.date.day) {
            continue;
          }
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
    return HSVColor.fromAHSV(1, hue, 0.65, 0.85).toColor();
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

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "By Category",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 260,
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(show: true),
                    alignment: BarChartAlignment.spaceAround,
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= keys.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                keys[index],
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(keys.length, (i) {
                      final value = data[keys[i]]!;
                      final color = _generateColor(i, keys.length);
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: value,
                            color: color,
                            width: 18,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
