import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../feature/onboarding/bloc/user/bloc_user.dart';

DateTime now = DateTime.now();

final formatMoney = NumberFormat.currency(
    locale: 'en', customPattern: '#,###', decimalDigits: 2);

String calculatorBalance(
    BuildContext context, double incomeBalance, double expenseBalance) {
  final totalBalance = incomeBalance - expenseBalance;
  final String symbol =
      BlocProvider.of<UserBloc>(context).userModel?.currencySymbol ?? '\$';
  return totalBalance == 0
      ? '${symbol}0.00'
      : '${totalBalance > 0 ? "" : "-"}$symbol${formatMoney.format(totalBalance).substring(totalBalance > 0 ? 0 : 1)}';
}

int randomIndex(int lengthList) {
  final _random = Random();

  final int element = _random.nextInt(lengthList);
  return element;
}

bool isSameMonth(DateTime date1, DateTime date2) {
  final dateFormat = DateFormat('yyyy-MM');
  return dateFormat.format(date1) == dateFormat.format(date2);
}

bool isSameDay(DateTime date1, DateTime date2) {
  final dateFormat = DateFormat('yyyy-MM-dd');
  return dateFormat.format(date1) == dateFormat.format(date2);
}
