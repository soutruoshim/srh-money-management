import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:monsey/common/model/transaction_model.dart';
import 'package:monsey/common/model/wallet_model.dart';
import 'package:monsey/common/preference/shared_preference_builder.dart';
import 'package:monsey/common/util/format_time.dart';
import 'package:monsey/common/widget/animation_click.dart';
import 'package:monsey/translations/export_lang.dart';

import '../../../app/widget_support.dart';
import '../../../common/constant/colors.dart';
import '../../../common/constant/images.dart';
import '../../../common/constant/styles.dart';
import '../../../common/route/routes.dart';
import '../../../common/util/ads_native.dart';
import '../../../common/util/helper.dart';
import '../../../common/widget/slidaction_widget.dart';
import '../../onboarding/bloc/user/bloc_user.dart';
import '../bloc/transactions/bloc_transactions.dart';
import '../screen/handle_transaction.dart';

const _kAdIndex = 3;

int _getDestinationItemIndex(int rawIndex, NativeAd? _ad) {
  if (rawIndex >= _kAdIndex && _ad != null) {
    return rawIndex - 1;
  }
  return rawIndex;
}

Widget totalBalance(
    BuildContext context, String type, String icon, double balance) {
  final String symbol =
      BlocProvider.of<UserBloc>(context).userModel?.currencySymbol ?? '\$';
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    decoration:
        BoxDecoration(color: white, borderRadius: BorderRadius.circular(12)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Image.asset(
                icon,
                width: 16,
                height: 16,
                color: type == 'income' ? bleuDeFrance : redCrayola,
              ),
            ),
            Text(
              type == 'income'
                  ? LocaleKeys.income.tr()
                  : LocaleKeys.expense.tr(),
              style: body(context: context),
            )
          ],
        ),
        Text(
          balance == 0
              ? '${symbol}0.00'
              : '${type != 'income' ? "-" : ""} $symbol${formatMoney.format(balance).substring(balance >= 0 ? 0 : 1)}',
          style: title3(color: type == 'income' ? bleuDeFrance : redCrayola),
        )
      ],
    ),
  );
}

void removeTransaction(
  BuildContext context,
  TransactionModel? transactionModel,
  DateTime? startDate,
  DateTime? endDate,
) {
  BlocProvider.of<TransactionsBloc>(context)
      .add(RemoveTransaction(transactionModel!, startDate, endDate));
  Navigator.of(context).pop();
}

Widget transactionsInDay(
    BuildContext context,
    WalletModel walletModel,
    TransactionInDayModel transactionsInDay,
    DateTime? startDate,
    DateTime? endDate,
    {bool showAds = false,
    NativeAd? ad}) {
  final int length = transactionsInDay.transactions.length;
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration:
        BoxDecoration(color: white, borderRadius: BorderRadius.circular(16)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            FormatTime.formatTime(
                    dateTime: transactionsInDay.date, format: Format.EMd)
                .toUpperCase(),
            style: title4(context: context),
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 16),
          height: 1,
          decoration: const BoxDecoration(color: grey6),
        ),
        ListView.separated(
          separatorBuilder: (context, index) {
            return Container(
              width: double.infinity,
              height: 1,
              decoration: const BoxDecoration(color: grey6),
            );
          },
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: length < 4 ? length + 1 : length + (ad != null ? 1 : 0),
          itemBuilder: (context, index) {
            transactionsInDay.transactions
                .sort((a, b) => b.date.compareTo(a.date));
            if (length < 4) {
              return index == length
                  ? (showAds ? const AdsNative() : const SizedBox())
                  : SlidactionWidget(
                      showLabel: false,
                      extentRatio: 0.4,
                      editFunc: () {
                        Navigator.of(context)
                            .pushNamed(Routes.handleTransaction,
                                arguments: HandleTransaction(
                                  walletModel: walletModel,
                                  transactionModel:
                                      transactionsInDay.transactions[index],
                                  startDate: startDate,
                                  endDate: endDate,
                                ));
                      },
                      removeFunc: () {
                        AppWidget.showDialogCustom(
                            LocaleKeys.removeThisTransaction.tr(),
                            context: context, remove: () {
                          removeTransaction(
                              context,
                              transactionsInDay.transactions[index],
                              startDate,
                              endDate);
                        });
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(Routes.handleTransaction,
                                  arguments: HandleTransaction(
                                    walletModel: walletModel,
                                    transactionModel:
                                        transactionsInDay.transactions[index],
                                    startDate: startDate,
                                    endDate: endDate,
                                  ));
                        },
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          leading: Image.network(
                              transactionsInDay
                                  .transactions[index].categoryModel!.icon,
                              width: 24,
                              height: 24),
                          minLeadingWidth: 12,
                          title: Text(
                            transactionsInDay.transactions[index].note ??
                                transactionsInDay
                                    .transactions[index].categoryModel!.name,
                            style: body(context: context),
                          ),
                          subtitle: Text(
                            FormatTime.formatTime(
                                dateTime:
                                    transactionsInDay.transactions[index].date,
                                format: Format.mdy),
                            style: subhead(color: grey3),
                          ),
                          trailing: Text(
                            '${transactionsInDay.transactions[index].type == 'income' ? "" : "-"}${BlocProvider.of<UserBloc>(context).userModel?.currencySymbol ?? '\$'}${formatMoney.format(transactionsInDay.transactions[index].balance)}',
                            style: callout(
                                color: transactionsInDay
                                            .transactions[index].type ==
                                        'income'
                                    ? bleuDeFrance
                                    : redCrayola),
                          ),
                        ),
                      ),
                    );
            } else {
              final item = transactionsInDay
                  .transactions[_getDestinationItemIndex(index, ad)];
              return ad != null && index == _kAdIndex
                  ? (showAds ? const AdsNative() : const SizedBox())
                  : SlidactionWidget(
                      showLabel: false,
                      extentRatio: 0.4,
                      editFunc: () {
                        Navigator.of(context)
                            .pushNamed(Routes.handleTransaction,
                                arguments: HandleTransaction(
                                  walletModel: walletModel,
                                  transactionModel: item,
                                  startDate: startDate,
                                  endDate: endDate,
                                ));
                      },
                      removeFunc: () {
                        AppWidget.showDialogCustom(
                            LocaleKeys.removeThisTransaction.tr(),
                            context: context, remove: () {
                          removeTransaction(context, item, startDate, endDate);
                        });
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(Routes.handleTransaction,
                                  arguments: HandleTransaction(
                                    walletModel: walletModel,
                                    transactionModel: item,
                                    startDate: startDate,
                                    endDate: endDate,
                                  ));
                        },
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(item.categoryModel!.icon,
                                  width: 24, height: 24)
                            ],
                          ),
                          minLeadingWidth: 12,
                          title: Text(
                            item.note ?? item.categoryModel!.name,
                            style: body(context: context),
                          ),
                          subtitle: Text(
                            FormatTime.formatTime(
                                dateTime: item.date, format: Format.mdy),
                            style: subhead(color: grey3),
                          ),
                          trailing: Text(
                            '${item.type == 'income' ? "" : "-"}${BlocProvider.of<UserBloc>(context).userModel?.currencySymbol ?? '\$'}${formatMoney.format(item.balance)}',
                            style: callout(
                                color: item.type == 'income'
                                    ? bleuDeFrance
                                    : redCrayola),
                          ),
                        ),
                      ),
                    );
            }
          },
        )
      ],
    ),
  );
}

Widget addTransaction(BuildContext context, WalletModel walletModel,
    {double padding = 16, DateTime? startDate, DateTime? endDate}) {
  return AnimationClick(
    function: () async {
      final previousCategory = await getCategory();
      Navigator.of(context).pushNamed(Routes.handleTransaction,
          arguments: HandleTransaction(
            walletModel: walletModel,
            previousCategoryModel: previousCategory,
            startDate: startDate,
            endDate: endDate,
          ));
    },
    child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
            color: emerald, borderRadius: BorderRadius.circular(20)),
        child: const Icon(
          Icons.add,
          size: 24,
          color: white,
        )),
  );
}

Widget transactionsAllDays(BuildContext context, WalletModel walletModel,
    List<TransactionInDayModel> transactionInMonth,
    {Function()? function,
    DateTime? startDate,
    DateTime? endDate,
    NativeAd? ad}) {
  transactionInMonth.toSet();
  transactionInMonth.sort((a, b) => b.date.compareTo(a.date));
  double totalIncome = 0;
  double totalExpense = 0;
  for (TransactionInDayModel transactionInDayModel in transactionInMonth) {
    for (TransactionModel transactionModel
        in transactionInDayModel.transactions) {
      if (transactionModel.type == 'income') {
        totalIncome += transactionModel.balance;
      } else {
        totalExpense += transactionModel.balance;
      }
    }
  }
  return ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Row(
        children: [
          Expanded(
            child: totalBalance(context, 'income', icIncome2, totalIncome),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: totalBalance(context, 'expense', icExpense, totalExpense),
          )
        ],
      ),
      const SizedBox(height: 16),
      transactionInMonth.isEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.transactions.tr().toUpperCase(),
                        style: title4(context: context),
                      ),
                      addTransaction(context, walletModel,
                          padding: 10, startDate: startDate, endDate: endDate)
                    ],
                  ),
                  AppWidget.divider(context, vertical: 8),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 32, right: 32, top: 16),
                    child: Text(LocaleKeys.tapButton.tr().toUpperCase(),
                        textAlign: TextAlign.center,
                        style: title4(color: grey3)),
                  )
                ],
              ))
          : ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(height: 16);
              },
              padding: const EdgeInsets.symmetric(vertical: 0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactionInMonth.length,
              itemBuilder: (context, index) {
                return transactionsInDay(context, walletModel,
                    transactionInMonth[index], startDate, endDate,
                    showAds: index == 0 ? true : false, ad: ad);
              },
            )
    ],
  );
}
