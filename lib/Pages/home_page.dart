import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spring_autumn/Widgets/Transaction/add_transaction_sheet.dart';
import 'package:spring_autumn/Widgets/Custom/custom_bold_text.dart';
import 'package:spring_autumn/Widgets/Custom/custom_floating_action_button.dart';
import 'package:spring_autumn/Widgets/Cards/home_balance_container.dart';
import 'package:spring_autumn/Widgets/Transaction/recent_transactions.dart';

final ValueNotifier<DateTime?> selectedMonthNotifier = ValueNotifier<DateTime?>(
  null,
);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<DateTime?>(
        valueListenable: selectedMonthNotifier,
        builder: (context, month, _) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    HomeBalanceContainer(),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomBoldText(
                            text: "Recent Transactions",
                            size: 20,
                          ),

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
                                      colorScheme: theme.colorScheme,
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
                  ],
                ),
              ),
              RecentTransactions(filter: TransactionFilter.all, month: month),
            ],
          );
        },
      ),
    );
  }
}
