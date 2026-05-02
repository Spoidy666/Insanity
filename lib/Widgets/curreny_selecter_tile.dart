import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spring_autumn/Bloc/currency/currency_cubit.dart';
import 'package:spring_autumn/Widgets/Custom/custom_primary_text.dart';
import 'package:spring_autumn/Widgets/Custom/custom_snackbar.dart';

class CurrencySelectorTile extends StatelessWidget {
  const CurrencySelectorTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrencyCubit, AppCurrency>(
      builder: (context, selectedCurrency) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Row(
            children: [
              const SizedBox(width: 15),
              Icon(selectedCurrency.icon),
              const SizedBox(width: 10),
              const CustomPrimaryText(text: "Currency", size: 15),
            ],
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(right: 25),
            child: DropdownButton<AppCurrency>(
              borderRadius: BorderRadius.circular(10),
              value: selectedCurrency,
              underline: const SizedBox(),
              items: AppCurrency.values.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text("${currency.code} (${currency.symbol})"),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  context.read<CurrencyCubit>().changeCurrency(value);
                  CustomSnackbar.show(
                    context,
                    message: "Currency changed to ${value.code}",
                    type: SnackbarType.success,
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
