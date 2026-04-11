import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spring_autumn/Bloc/currency/currency_cubit.dart';
import 'package:spring_autumn/Bloc/profile/profile_cubit.dart';
import 'package:spring_autumn/Bloc/theme_state.dart';
import 'package:spring_autumn/Bloc/transactions/transaction__event.dart';
import 'package:spring_autumn/Bloc/transactions/transaction_bloc.dart';
import 'package:spring_autumn/Database/database_helper.dart';
import 'package:spring_autumn/Model/transaction_model.dart';
import 'package:spring_autumn/Pages/main_page.dart';

late Method defaultMethod;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDatabase();
  final prefs = await SharedPreferences.getInstance();
  final value = prefs.getString('default_method');

  defaultMethod = Method.values.firstWhere(
    (e) => e.name == value,
    orElse: () => Method.cash,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()),
        BlocProvider(create: (_) => CurrencyCubit()),
        BlocProvider(create: (_) => ProfileCubit()),
        BlocProvider<TransactionBloc>(
          create: (_) => TransactionBloc()..add(LoadTransactions()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(theme: state.themeData, home: const MainPage());
        },
      ),
    );
  }
}
