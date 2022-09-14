import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:monsey/app/widget_support.dart';
import 'package:monsey/common/constant/colors.dart';
import 'package:monsey/common/constant/env.dart';
import 'package:monsey/common/constant/styles.dart';
import 'package:monsey/common/model/category_model.dart';
import 'package:monsey/common/model/transaction_model.dart';
import 'package:monsey/common/model/wallet_model.dart';
import 'package:monsey/common/preference/shared_preference_builder.dart';
import 'package:monsey/common/route/routes.dart';
import 'package:monsey/common/util/format_time.dart';
import 'package:monsey/common/widget/animation_click.dart';
import 'package:monsey/common/widget/app_bar_cpn.dart';
import 'package:monsey/common/widget/unfocus_click.dart';
import 'package:monsey/feature/home/bloc/wallets/bloc_wallets.dart';
import 'package:monsey/feature/transaction/bloc/transactions/bloc_transactions.dart';
import 'package:monsey/feature/transaction/screen/select_wallet.dart';
import 'package:monsey/translations/export_lang.dart';

import '../../../common/constant/images.dart';
import '../../../common/util/helper.dart';
import '../../../common/widget/textfield_balance.dart';
import '../widget/calendar.dart';

const int maxFailedLoadAttempts = 3;

class HandleTransaction extends StatefulWidget {
  const HandleTransaction(
      {Key? key,
      this.transactionModel,
      required this.walletModel,
      this.previousCategoryModel,
      this.startDate,
      this.endDate})
      : super(key: key);
  final TransactionModel? transactionModel;
  final WalletModel walletModel;
  final CategoryModel? previousCategoryModel;
  final DateTime? startDate;
  final DateTime? endDate;
  @override
  State<HandleTransaction> createState() => _HandleTransactionState();
}

class _HandleTransactionState extends State<HandleTransaction>
    with SingleTickerProviderStateMixin {
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  late TabController _controller;
  late int _currentIndex = 0;
  String? note;
  String? nameWallet;
  String? nameCategory;
  String? iconCategory;
  DateTime? date;
  late TextEditingController balanceExpenseCtl;
  FocusNode balanceExpenseFn = FocusNode();
  late TextEditingController balanceIncomeCtl;
  FocusNode balanceIncomeFn = FocusNode();

  CategoryModel? categoryModel;
  WalletModel? walletModel;
  late WalletsBloc walletsBloc;
  late TransactionsBloc transactionsBloc;

  bool isCreate = true;
  bool clickedBlack = false;

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper().interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  Future<void> setNameWallet() async {
    final result = await Navigator.of(context).pushNamed(Routes.selectWallet,
        arguments: const SelectWallet()) as WalletModel;
    setState(() {
      walletModel = result;
      nameWallet = result.name;
    });
  }

  Future<void> setNote() async {
    final result =
        await Navigator.of(context).pushNamed(Routes.noteTransaction) as String;
    if (result != '')
      setState(() {
        note = result;
      });
  }

  Future<void> setNameCategory() async {
    final result = await Navigator.of(context).pushNamed(_currentIndex == 0
        ? Routes.expenseCategories
        : Routes.incomeCategories) as CategoryModel?;
    if (result != null) {
      setState(() {
        categoryModel = result;
        nameCategory = result.name;
        iconCategory = result.icon;
      });
    }
  }

  Future<void> setDate() async {
    await showModalBottomSheet<DateTime>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: white,
      builder: (BuildContext context) {
        return CalendarCpn(previousSelectedDate: date ?? now);
      },
      context: context,
    ).then((dynamic value) {
      if (value != null) {
        setState(() {
          date = value;
        });
      }
    });
  }

  Widget itemTabView(bool isExpense) {
    return ListView(
      children: [
        TextFieldBalanceCpn(
            isExpense: isExpense,
            isCreateTransaction: true,
            controller: isExpense ? balanceExpenseCtl : balanceIncomeCtl,
            focusNode: isExpense ? balanceExpenseFn : balanceIncomeFn,
            showPrefixIcon: true),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              AnimationClick(
                function: setNameCategory,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          iconCategory != null
                              ? Image.network(iconCategory!,
                                  width: 24, height: 24)
                              : Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                      color: grey5,
                                      borderRadius: BorderRadius.circular(24)),
                                ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                nameCategory ?? LocaleKeys.category.tr(),
                                style: body(
                                    color: categoryModel == null && isCreate
                                        ? grey3
                                        : grey1),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: grey3,
                    )
                  ],
                ),
              ),
              AppWidget.divider(context, vertical: 16),
              AnimationClick(
                function: setNameWallet,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          isCreate
                              ? Image.asset(
                                  icWallet,
                                  width: 24,
                                  height: 24,
                                  color: purplePlum,
                                )
                              : Image.network(
                                  widget.walletModel.typeWalletModel!.icon,
                                  width: 24,
                                  height: 24,
                                  color: purplePlum,
                                ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                nameWallet ?? LocaleKeys.wallet.tr(),
                                style: body(
                                    color: nameWallet == null && isCreate
                                        ? grey3
                                        : grey1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: grey3,
                    )
                  ],
                ),
              ),
              AppWidget.divider(context, vertical: 16),
              AnimationClick(
                function: setDate,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Image.asset(icCalendar,
                              width: 24, height: 24, color: purplePlum),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                FormatTime.formatTime(
                                    dateTime: date, format: Format.EMd),
                                style: body(color: grey1),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: grey3,
                    )
                  ],
                ),
              ),
              AppWidget.divider(context, vertical: 16),
              AnimationClick(
                function: setNote,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Image.asset(
                            icNote,
                            width: 24,
                            height: 24,
                            color: purplePlum,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: Text(
                                note ?? LocaleKeys.note.tr(),
                                style: body(
                                    color: note == null && isCreate
                                        ? grey3
                                        : grey1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_right_rounded,
                      color: grey3,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void editTransaction() {
    final String balance =
        _currentIndex == 0 ? balanceExpenseCtl.text : balanceIncomeCtl.text;
    transactionsBloc.add(EditTransaction(
        TransactionModel(
            id: widget.transactionModel!.id,
            balance: double.tryParse(balance.substring(1).replaceAll(',', ''))!,
            categoryModel: categoryModel,
            categoryId: categoryModel!.id,
            walletId: walletModel!.id!,
            type: _currentIndex == 0 ? 'expense' : 'income',
            date: date ?? now,
            note: note!),
        widget.startDate,
        widget.endDate));
    Navigator.of(context).pop();
  }

  void removeTransaction() {
    if (!isCreate && widget.transactionModel != null) {
      transactionsBloc.add(RemoveTransaction(
          widget.transactionModel!, widget.startDate, widget.endDate));
    }
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
    isCreate = widget.transactionModel == null;
    balanceExpenseCtl = TextEditingController(
        text: isCreate ? '-0' : '-${widget.transactionModel!.balance}');
    balanceIncomeCtl = TextEditingController(
        text: isCreate ? '+0' : '+${widget.transactionModel!.balance}');
    nameCategory = isCreate
        ? (widget.previousCategoryModel != null
            ? widget.previousCategoryModel!.name
            : null)
        : widget.transactionModel!.categoryModel!.name;
    nameWallet = widget.walletModel.name;
    date = isCreate ? null : widget.transactionModel!.date;
    note = isCreate ? null : widget.transactionModel!.note;
    categoryModel = isCreate
        ? widget.previousCategoryModel
        : widget.transactionModel!.categoryModel;
    walletModel = widget.walletModel;
    iconCategory = isCreate
        ? (widget.previousCategoryModel != null
            ? widget.previousCategoryModel!.icon
            : null)
        : widget.transactionModel!.categoryModel!.icon;
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    walletsBloc = BlocProvider.of<WalletsBloc>(context);
    transactionsBloc = BlocProvider.of<TransactionsBloc>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    balanceIncomeCtl.dispose();
    balanceIncomeFn.dispose();
    balanceExpenseCtl.dispose();
    balanceExpenseFn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = AppWidget.getHeightScreen(context);
    final bool checked = categoryModel != null;
    return UnfocusClick(
      child: Scaffold(
        appBar: AppBarCpn(
          color: white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    if (isCreate) {
                      Navigator.of(context).pop();
                    } else {
                      setState(() {
                        clickedBlack = true;
                      });
                    }
                  },
                  icon: Image.asset(icArrowLeft, width: 24, height: 24)),
              Text(
                isCreate
                    ? LocaleKeys.createTransaction.tr()
                    : LocaleKeys.editTransaction.tr(),
                style: headline(context: context),
              ),
              isCreate
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        AppWidget.showDialogCustom(
                            LocaleKeys.removeThisTransaction.tr(),
                            context: context,
                            remove: removeTransaction);
                      },
                      icon: const Icon(Icons.delete_outline_rounded,
                          size: 24, color: grey1),
                    )
            ],
          ),
          bottom: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
                color: grey6, borderRadius: BorderRadius.circular(20)),
            child: TabBar(
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              controller: _controller,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: _currentIndex == 0 ? redCrayola : bleuDeFrance,
              ),
              labelStyle: headline(color: purplePlum),
              unselectedLabelStyle: headline(color: grey2),
              labelColor: white,
              unselectedLabelColor: grey3,
              indicatorColor: purplePlum,
              labelPadding: const EdgeInsets.symmetric(horizontal: 0),
              tabs: [
                Tab(text: LocaleKeys.expense.tr()),
                Tab(text: LocaleKeys.income.tr()),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          height: clickedBlack ? height / 8 : null,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: isCreate
              ? AppWidget.typeButtonStartAction(
                  context: context,
                  input: LocaleKeys.create.tr(),
                  onPressed: checked
                      ? () async {
                          final String balance = _currentIndex == 0
                              ? balanceExpenseCtl.text
                              : balanceIncomeCtl.text;

                          await setCategory(categoryModel!);

                          transactionsBloc.add(CreateTransaction(
                              TransactionModel(
                                  balance: double.tryParse(balance
                                      .substring(1)
                                      .replaceAll(',', ''))!,
                                  categoryId: categoryModel!.id,
                                  categoryModel: categoryModel!,
                                  walletId: walletModel!.id!,
                                  type:
                                      _currentIndex == 0 ? 'expense' : 'income',
                                  date: date ?? now,
                                  note: note ?? categoryModel!.name),
                              widget.startDate,
                              widget.endDate));
                          final int amount = await getAmountTransCreate();
                          if (amount == 2) {
                            _showInterstitialAd();
                          }
                          Navigator.of(context).pop();
                        }
                      : () {},
                  bgColor: checked ? emerald : grey5,
                  textColor: white)
              : clickedBlack
                  ? Column(
                      children: [
                        Expanded(
                          child: AppWidget.typeButtonStartAction(
                              context: context,
                              input: LocaleKeys.discardChanges.tr(),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              borderColor: purplePlum,
                              bgColor: white,
                              textColor: purplePlum),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: AppWidget.typeButtonStartAction(
                              context: context,
                              input: LocaleKeys.keepEditing.tr(),
                              onPressed: () {
                                editTransaction();
                              },
                              bgColor: emerald,
                              textColor: white),
                        ),
                      ],
                    )
                  : AppWidget.typeButtonStartAction(
                      context: context,
                      input: LocaleKeys.save.tr(),
                      onPressed: () {
                        editTransaction();
                      },
                      bgColor: emerald,
                      textColor: white),
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            itemTabView(true),
            itemTabView(false),
          ],
        ),
      ),
    );
  }
}
