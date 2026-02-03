import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spring_autumn/Bloc/transactions/transaction_bloc.dart';
import 'package:spring_autumn/Bloc/transactions/transaction_state.dart';
import 'package:spring_autumn/Widgets/custom_bold_text.dart';
import 'package:spring_autumn/Widgets/custom_primary_text.dart';

class HomeBalanceContainer extends StatelessWidget {
  const HomeBalanceContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        int balance = 0;

        if (state is TransactionLoaded) {
          balance = state.balance;
        }

        return Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomPrimaryText(text: "Remaining Balance", size: 17),
                Row(
                  children: [
                    const Icon(Icons.currency_rupee, size: 45),
                    CustomBoldText(text: balance.toString(), size: 45),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
