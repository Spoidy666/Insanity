import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spring_autumn/Bloc/currency/currency_cubit.dart';
import 'package:spring_autumn/Bloc/transactions/transaction_bloc.dart';
import 'package:spring_autumn/Bloc/transactions/transaction_state.dart';
import 'package:spring_autumn/Widgets/custom_bold_text.dart';
import 'package:spring_autumn/Widgets/custom_primary_text.dart';

class HomeBalanceContainer extends StatefulWidget {
  const HomeBalanceContainer({super.key});

  @override
  State<HomeBalanceContainer> createState() => _HomeBalanceContainerState();
}

class _HomeBalanceContainerState extends State<HomeBalanceContainer>
    with SingleTickerProviderStateMixin {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is! TransactionLoaded) {
          return const SizedBox.shrink();
        }

        return BlocBuilder<CurrencyCubit, AppCurrency>(
          builder: (context, currency) {
            final total = state.cash + state.card + state.upi;

            final formatter = NumberFormat.currency(
              locale: currency.locale,
              symbol: currency.symbol,
              decimalDigits: currency.decimalDigits,
            );

            return GestureDetector(
              onTap: () => setState(() => expanded = !expanded),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomPrimaryText(
                      text: "Remaining Balance",
                      size: 17,
                    ),

                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: CustomBoldText(
                        text: formatter.format(total),
                        size: 42,
                      ),
                    ),

                    ClipRect(
                      child: AnimatedAlign(
                        alignment: Alignment.topCenter,
                        heightFactor: expanded ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOutCubic,
                        child: AnimatedOpacity(
                          opacity: expanded ? 1 : 0,
                          duration: const Duration(milliseconds: 180),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
                            child: Column(
                              children: [
                                _methodRow(
                                  "Cash",
                                  state.cash,
                                  currency,
                                  formatter,
                                ),
                                _methodRow(
                                  "Card",
                                  state.card,
                                  currency,
                                  formatter,
                                ),
                                _methodRow(
                                  "UPI",
                                  state.upi,
                                  currency,
                                  formatter,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _methodRow(
    String label,
    double amount,
    AppCurrency currency,
    NumberFormat formatter,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          CustomBoldText(text: formatter.format(amount), size: 14),
        ],
      ),
    );
  }
}
