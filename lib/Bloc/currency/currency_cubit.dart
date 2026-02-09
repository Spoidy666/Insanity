import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppCurrency { inr, usd, eur, gbp, jpy, aud, cad, sgd, aed }

extension CurrencyExtension on AppCurrency {
  String get symbol {
    switch (this) {
      case AppCurrency.inr:
        return "₹";
      case AppCurrency.usd:
        return "\$";
      case AppCurrency.eur:
        return "€";
      case AppCurrency.gbp:
        return "£";
      case AppCurrency.jpy:
        return "¥";
      case AppCurrency.aud:
        return "A\$";
      case AppCurrency.cad:
        return "C\$";
      case AppCurrency.sgd:
        return "S\$";
      case AppCurrency.aed:
        return "د.إ";
    }
  }

  String get code {
    return name.toUpperCase();
  }

  int get decimalDigits {
    switch (this) {
      case AppCurrency.jpy:
        return 0; 
      default:
        return 2;
    }
  }

  IconData get icon {
    switch (this) {
      case AppCurrency.inr:
        return Icons.currency_rupee;
      case AppCurrency.usd:
      case AppCurrency.aud:
      case AppCurrency.cad:
      case AppCurrency.sgd:
        return Icons.attach_money;
      case AppCurrency.eur:
        return Icons.euro;
      case AppCurrency.gbp:
        return Icons.currency_pound;
      case AppCurrency.jpy:
        return Icons.currency_yen;
      case AppCurrency.aed:
        return Icons.payments;
    }
  }
  String get locale {
  switch (this) {
    case AppCurrency.inr:
      return 'en_IN'; 
    case AppCurrency.usd:
      return 'en_US';
    case AppCurrency.eur:
      return 'de_DE'; 
    case AppCurrency.gbp:
      return 'en_GB';
    case AppCurrency.jpy:
      return 'ja_JP';
    case AppCurrency.aud:
      return 'en_AU';
    case AppCurrency.cad:
      return 'en_CA';
    case AppCurrency.sgd:
      return 'en_SG';
    case AppCurrency.aed:
      return 'en_AE';
  }
}

}

class CurrencyCubit extends Cubit<AppCurrency> {
  CurrencyCubit() : super(AppCurrency.inr) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('app_currency');
    emit(AppCurrency.values.byName(value ?? 'inr'));
  }

  Future<void> changeCurrency(AppCurrency currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_currency', currency.name);
    emit(currency);
  }
}
