import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:spring_autumn/Bloc/currency/currency_cubit.dart';
import 'package:spring_autumn/Bloc/transactions/transaction__event.dart';
import 'package:spring_autumn/Bloc/transactions/transaction_bloc.dart';
import 'package:spring_autumn/Bloc/transactions/transaction_state.dart';
import 'package:spring_autumn/Database/database_helper.dart';
import 'package:spring_autumn/Model/transaction_model.dart';
import '../Cards/transaction_tile.dart';

enum TransactionFilter { all, income, expense }

class RecentTransactions extends StatelessWidget {
  final TransactionFilter filter;
  final DateFilter? dateFilter;

  const RecentTransactions({
    super.key,
    required this.filter,
    required this.dateFilter,
  });

  Map<String, double> _buildMonthTotals(
    List<Map<String, Object?>> transactions,
  ) {
    final Map<String, double> totals = {};

    for (final tx in transactions) {
      final timestamp = tx['transaction_timestamp'] as int;
      final amount = (tx['amount'] as num).toDouble();
      final type = tx['type'] as String;
      final label = _monthLabel(timestamp);

      final signed = type == 'income' ? amount : -amount;
      totals[label] = (totals[label] ?? 0) + signed;
    }

    return totals;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoading) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is TransactionLoaded) {
          final filteredTransactions =
              state.transactions.where((tx) {
                final type = tx['type'] as String;
                switch (filter) {
                  case TransactionFilter.income:
                    if (type != 'income') return false;
                    break;
                  case TransactionFilter.expense:
                    if (type != 'expense') return false;
                    break;
                  case TransactionFilter.all:
                    break;
                }

                if (dateFilter != null) {
                  final txDate = DateTime.fromMillisecondsSinceEpoch(
                    tx['transaction_timestamp'] as int,
                  );

                  if (dateFilter!.mode == DateFilterMode.month) {
                    if (txDate.year != dateFilter!.date.year ||
                        txDate.month != dateFilter!.date.month) {
                      return false;
                    }
                  } else {
                    if (txDate.year != dateFilter!.date.year ||
                        txDate.month != dateFilter!.date.month ||
                        txDate.day != dateFilter!.date.day) {
                      return false;
                    }
                  }
                }

                return true;
              }).toList()..sort(
                (a, b) => (b['transaction_timestamp'] as int).compareTo(
                  a['transaction_timestamp'] as int,
                ),
              );

          if (filteredTransactions.isEmpty) {
            return const SliverFillRemaining(
              child: Center(child: Text('No transactions yet')),
            );
          }

          final monthTotals = _buildMonthTotals(filteredTransactions);

          return BlocBuilder<CurrencyCubit, AppCurrency>(
            builder: (context, currency) {
              return AnimationLimiter(
                child: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final tx = filteredTransactions[index];

                    final timestamp = tx['transaction_timestamp'] as int;
                    final categoryId = tx['category_id'] as String;
                    final categoryName =
                        state.categoryMap[categoryId] ?? "Unknown";

                    final currentMonth = _monthLabel(timestamp);
                    final previousMonth = index == 0
                        ? null
                        : _monthLabel(
                            filteredTransactions[index -
                                    1]['transaction_timestamp']
                                as int,
                          );

                    final showHeader = currentMonth != previousMonth;
                    final monthTotal = monthTotals[currentMonth] ?? 0;
                    final isPositive = monthTotal >= 0;

                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 220),
                      child: SlideAnimation(
                        verticalOffset: 20,
                        child: FadeInAnimation(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (showHeader)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    12,
                                    16,
                                    16,
                                    8,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        currentMonth,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        "${isPositive ? '+' : ''}${NumberFormat.currency(locale: currency.locale, symbol: currency.symbol, decimalDigits: currency.decimalDigits).format(monthTotal)}",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: isPositive
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              TransactionSlidableTile(
                                tx: tx,
                                categoryName: categoryName,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }, childCount: filteredTransactions.length),
                ),
              );
            },
          );
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  String _monthLabel(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return "${_monthName(date.month)} ${date.year}";
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}

class TransactionSlidableTile extends StatefulWidget {
  final Map<String, Object?> tx;
  final String categoryName;

  const TransactionSlidableTile({
    super.key,
    required this.tx,
    required this.categoryName,
  });

  @override
  State<TransactionSlidableTile> createState() =>
      _TransactionSlidableTileState();
}

class _TransactionSlidableTileState extends State<TransactionSlidableTile>
    with SingleTickerProviderStateMixin {
  late final SlidableController _controller;
  bool _popupShown = false;

  @override
  void initState() {
    super.initState();
    _controller = SlidableController(this);
    _controller.animation.addListener(_handleSlide);
  }

  void _handleSlide() {
    if (_controller.animation.value >= 0.4 && !_popupShown) {
      _popupShown = true;
      _showActionPopup(context, widget.tx);
      _controller.close();
    }
  }

  @override
  void dispose() {
    _controller.animation.removeListener(_handleSlide);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Slidable(
        key: ValueKey(widget.tx['id']),
        controller: _controller,
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          extentRatio: 0.5,
          children: [
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                alignment: Alignment.center,
                child: Icon(Iconsax.trash, color: Colors.red),
              ),
            ),
          ],
        ),
        child: TransactionTile(
          transaction: widget.tx,
          categoryName: widget.categoryName,
        ),
      ),
    );
  }

  void _showActionPopup(BuildContext context, Map<String, Object?> tx) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Delete Transaction?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "This action cannot be undone.",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          await deleteTransaction(tx['id'] as String);
                          context.read<TransactionBloc>().add(
                            TransactionDeleted(),
                          );
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      _popupShown = false;
    });
  }
}
