import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spring_autumn/Widgets/Graphs/bar_graph.dart';
import 'package:spring_autumn/Widgets/Custom/custom_bold_text.dart';
import 'package:spring_autumn/Widgets/Graphs/piechart.dart';
import 'package:spring_autumn/Widgets/Transaction/recent_transactions.dart';
import 'package:spring_autumn/Model/transaction_model.dart';

final ValueNotifier<DateFilter?> paymentsFilterNotifier =
    ValueNotifier<DateFilter?>(null);

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: ValueListenableBuilder<DateFilter?>(
        valueListenable: paymentsFilterNotifier,
        builder: (context, dateFilter, _) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomBoldText(text: "Expenses", size: 20),
                      TextButton.icon(
                        onLongPress: () {
                          paymentsFilterNotifier.value = null;
                        },
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: dateFilter?.date ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                            initialDatePickerMode: DatePickerMode.day,
                            builder: (context, child) {
                              final theme = Theme.of(context);
                              return Theme(
                                data: theme.copyWith(
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor:
                                          theme.colorScheme.tertiary,
                                    ),
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );

                          if (picked != null && context.mounted) {
                            final mode = await showModalBottomSheet<DateFilterMode>(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              builder: (ctx) => SafeArea(
                                top: false,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Filter by",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ListTile(
                                        leading: const Icon(Iconsax.calendar_1),
                                        title: Text(
                                          "This day  (${picked.day}/${picked.month}/${picked.year})",
                                        ),
                                        onTap: () => Navigator.pop(
                                          ctx,
                                          DateFilterMode.day,
                                        ),
                                      ),
                                      ListTile(
                                        leading: const Icon(Iconsax.calendar),
                                        title: Text(
                                          "This month  (${picked.month}/${picked.year})",
                                        ),
                                        onTap: () => Navigator.pop(
                                          ctx,
                                          DateFilterMode.month,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );

                            if (mode != null) {
                              paymentsFilterNotifier.value = DateFilter(
                                picked,
                                mode,
                              );
                            }
                          }
                        },
                        icon: Icon(
                          Iconsax.calendar_edit,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        label: Text(
                          dateFilter == null
                              ? "All time"
                              : dateFilter.mode == DateFilterMode.day
                              ? "${dateFilter.date.day}/${dateFilter.date.month}/${dateFilter.date.year}"
                              : "${dateFilter.date.month}/${dateFilter.date.year}",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      SizedBox(
                        width: screenWidth,
                        child: ExpensePieChartCard(
                          type: Type.expense,
                          dateFilter: dateFilter,
                        ),
                      ),
                      SizedBox(
                        width: screenWidth,
                        child: ExpenseBarChartCard(
                          type: Type.expense,
                          dateFilter: dateFilter,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              RecentTransactions(
                filter: TransactionFilter.expense,
                dateFilter: dateFilter,
              ),
            ],
          );
        },
      ),
    );
  }
}
