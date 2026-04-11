import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spring_autumn/Widgets/Transaction/add_transaction_sheet.dart';
import 'package:spring_autumn/Widgets/Graphs/bar_graph.dart';
import 'package:spring_autumn/Widgets/Custom/custom_bold_text.dart';
import 'package:spring_autumn/Widgets/Custom/custom_floating_action_button.dart';
import 'package:spring_autumn/Widgets/Graphs/piechart.dart';
import 'package:spring_autumn/Widgets/Transaction/recent_transactions.dart';
import 'package:spring_autumn/Model/transaction_model.dart';

final ValueNotifier<DateTime?> selectedMonthNotifier = ValueNotifier<DateTime?>(
  null,
);

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: ValueListenableBuilder<DateTime?>(
        valueListenable: selectedMonthNotifier,
        builder: (context, month, _) {
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
                          selectedMonthNotifier.value = null;
                        },
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: month ?? DateTime.now(),
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

                          if (picked != null) {
                            selectedMonthNotifier.value = DateTime(
                              picked.year,
                              picked.month,
                            );
                          }
                        },
                        icon: Icon(
                          Iconsax.calendar_edit,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        label: Text(
                          month == null
                              ? "All time"
                              : "${month.month}/${month.year}",
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
                          month: month,
                        ),
                      ),
                      SizedBox(
                        width: screenWidth,
                        child: ExpenseBarChartCard(
                          type: Type.expense,
                          month: month,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              RecentTransactions(
                filter: TransactionFilter.expense,
                month: month,
              ),
            ],
          );
        },
      ),

      floatingActionButton: CustomFloatingActionButton(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            builder: (_) => const AddTransactionSheet(),
          );
        },
        icon: Iconsax.card_receive,
      ),
    );
  }
}
