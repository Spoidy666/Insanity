import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spring_autumn/Model/transaction_model.dart';
import 'package:spring_autumn/Widgets/Custom/custom_button_one.dart';
import 'package:spring_autumn/Widgets/Custom/custom_snackbar.dart';
import 'package:spring_autumn/main.dart';

class DefaultMethodSheet extends StatelessWidget {
  DefaultMethodSheet({super.key});

  final ValueNotifier<Method> selectedMethodNotifier = ValueNotifier(
    defaultMethod,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder<Method>(
          valueListenable: selectedMethodNotifier,
          builder: (context, selectedMethod, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Default Payment Method",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                Center(
                  child: Wrap(
                    spacing: 10,
                    children: Method.values.map((method) {
                      final isSelected = selectedMethod == method;

                      return ChoiceChip(
                        label: Text(method.displayName),
                        selected: isSelected,
                        onSelected: (_) {
                          selectedMethodNotifier.value = method;
                        },
                        selectedColor: theme.colorScheme.secondary,
                        backgroundColor: theme.colorScheme.primary,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : theme.colorScheme.tertiary,
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: CustomButtonOne(
                    text: "Save",
                    onTap: () async {
                      final method = selectedMethodNotifier.value;

                      await saveDefaultMethod(method);
                      defaultMethod = method;

                      Navigator.pop(context, method);
                      CustomSnackbar.show(
                        context,
                        message: "Default method set to ${method.displayName}",
                        type: SnackbarType.success,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Future<void> saveDefaultMethod(Method method) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('default_method', method.name);
  _cachedMethod = method;
}

Method? _cachedMethod;

Future<Method> getDefaultMethod() async {
  if (_cachedMethod != null) return _cachedMethod!;

  final prefs = await SharedPreferences.getInstance();
  final value = prefs.getString('default_method');

  _cachedMethod = Method.values.firstWhere(
    (e) => e.name == value,
    orElse: () => Method.cash,
  );

  return _cachedMethod!;
}
