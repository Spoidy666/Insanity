import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spring_autumn/Bloc/transactions/transaction_bloc.dart';
import 'package:spring_autumn/Bloc/transactions/transaction_state.dart';
import 'package:spring_autumn/Model/transaction_model.dart';

class ExpenseLineChartCard extends StatelessWidget {
  final Type type;
  final DateTime? month;

  const ExpenseLineChartCard({
    super.key,
    required this.type,
    required this.month,
  });

  Map<int, double> _buildLineChartData(
    List<Map<String, Object?>> transactions,
  ) {
    final Map<int, double> data = {};

    if (month != null) {
      // Show daily data for a specific month
      final daysInMonth = DateUtils.getDaysInMonth(month!.year, month!.month);

      for (int i = 1; i <= daysInMonth; i++) {
        data[i] = 0.0;
      }

      for (final tx in transactions) {
        if (tx['type'] != type.name) continue;

        final txDate = DateTime.fromMillisecondsSinceEpoch(
          tx['transaction_timestamp'] as int,
        );

        if (txDate.year != month!.year || txDate.month != month!.month) {
          continue;
        }

        final day = txDate.day;
        final amount = (tx['amount'] as num).toDouble();
        data[day] = (data[day] ?? 0) + amount;
      }
    } else {
      // Show monthly data for all months
      for (int i = 1; i <= 12; i++) {
        data[i] = 0.0;
      }

      for (final tx in transactions) {
        if (tx['type'] != type.name) continue;

        final txDate = DateTime.fromMillisecondsSinceEpoch(
          tx['transaction_timestamp'] as int,
        );

        final monthNum = txDate.month;
        final amount = (tx['amount'] as num).toDouble();
        data[monthNum] = (data[monthNum] ?? 0) + amount;
      }
    }

    return data;
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);

    String text = '';

    if (month != null) {
      // Daily view - show selected days
      final day = value.toInt();
      if (day == 1 ||
          day == 10 ||
          day == 20 ||
          day == DateUtils.getDaysInMonth(month!.year, month!.month)) {
        text = day.toString();
      }
    } else {
      // Monthly view - show month abbreviations
      text = switch (value.toInt()) {
        1 => 'JAN',
        3 => 'MAR',
        5 => 'MAY',
        7 => 'JUL',
        9 => 'SEP',
        11 => 'NOV',
        _ => '',
      };
    }

    return SideTitleWidget(
      meta: meta,

      child: Text(text, style: style),
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta, double maxY) {
    const style = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);

    if (value == 0 || value == maxY / 2 || value == maxY) {
      return Text(
        NumberFormat.compact().format(value),
        style: style,
        textAlign: TextAlign.left,
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is! TransactionLoaded) {
          return const SizedBox.shrink();
        }

        final data = _buildLineChartData(state.transactions);

        if (data.isEmpty || data.values.every((v) => v == 0)) {
          return const SizedBox.shrink();
        }

        final maxY = data.values.reduce((a, b) => a > b ? a : b);
        final minX = data.keys.reduce((a, b) => a < b ? a : b).toDouble();
        final maxX = data.keys.reduce((a, b) => a > b ? a : b).toDouble();

        final spots =
            data.entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList()
              ..sort((a, b) => a.x.compareTo(b.x));

        final gradientColors = [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.tertiary,
          Theme.of(context).colorScheme.secondary,
        ];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                month != null
                    ? "Daily ${type.name == 'expense' ? 'Expenses' : 'Income'}"
                    : "Monthly ${type.name == 'expense' ? 'Expenses' : 'Income'}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              AspectRatio(
                aspectRatio: 1.70,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 18,
                    left: 12,
                    top: 24,
                    bottom: 12,
                  ),
                  child: LineChart(
                    LineChartData(
                      lineTouchData: LineTouchData(
                        handleBuiltInTouches: true,
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (touchedSpot) => Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.8),

                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                            return touchedBarSpots.map((barSpot) {
                              final flSpot = barSpot;
                              return LineTooltipItem(
                                '${month != null ? "Day " : ""}${flSpot.x.toInt()}\n',
                                TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: NumberFormat.compact().format(
                                      flSpot.y,
                                    ),
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surface,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              );
                            }).toList();
                          },
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: maxY / 5,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.05),
                            strokeWidth: 1,
                            dashArray: [5, 5],
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 1,
                            getTitlesWidget: _bottomTitleWidgets,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: maxY / 5,
                            getTitlesWidget: (value, meta) =>
                                _leftTitleWidgets(value, meta, maxY),
                            reservedSize: 42,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: minX,
                      maxX: maxX,
                      minY: 0,
                      maxY: maxY * 1.1,
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          curveSmoothness: 0.35,
                          gradient: LinearGradient(colors: gradientColors),
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            checkToShowDot: (spot, barData) => spot.y > 0,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: Theme.of(context).colorScheme.surface,
                                strokeWidth: 2,
                                strokeColor: Theme.of(
                                  context,
                                ).colorScheme.tertiary,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: gradientColors
                                  .map((color) => color.withValues(alpha: 0.2))
                                  .toList(),
                            ),
                          ),
                          shadow: Shadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.tertiary.withValues(alpha: 0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ),
                      ],
                    ),
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
