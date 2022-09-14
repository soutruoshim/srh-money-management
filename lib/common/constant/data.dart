import 'package:monsey/common/constant/images.dart';
import 'package:monsey/common/model/category_model.dart';
import 'package:monsey/common/model/transaction_model.dart';
import 'package:monsey/common/model/type_wallet_model.dart';
import 'package:monsey/common/model/wallet_model.dart';

import '../util/helper.dart';

const List<WalletModel> wallets = [
  WalletModel(
      name: 'wallet 1',
      id: 1,
      typeWalletModel: TypeWalletModel(name: 'Cash', icon: icCash, id: 1),
      incomeBalance: 12.46,
      expenseBalance: 8.45,
      typeWalletId: 1,
      userUuid: 'dungle'),
];

const List<TypeWalletModel> typeWalletsDefault = [
  TypeWalletModel(name: 'Cash', icon: icCash, id: 1),
  TypeWalletModel(name: 'Credit Card', icon: icCreditCard, id: 2),
  TypeWalletModel(name: 'Debit Card', icon: icDebitCard, id: 3),
  TypeWalletModel(name: 'Bank Account', icon: icBankAccount, id: 4),
  TypeWalletModel(name: 'E-Wallet', icon: icEWallet, id: 5),
];
List<TransactionModel> transactionsDemo = [
  TransactionModel(
      categoryModel: const CategoryModel(
          name: 'Wage, invoices', id: 1, icon: icWageInvoices, type: 'income'),
      balance: 23.5,
      categoryId: 1,
      walletId: 1,
      type: 'income',
      id: 1,
      date: now.subtract(const Duration(days: 2)),
      note: 'Shopping at Tokyo Life',
      updateAt: now,
      createAt: now),
  TransactionModel(
      categoryModel: const CategoryModel(
          name: 'Food & Drinks', id: 2, icon: icFood, type: 'expense'),
      balance: 23.5,
      categoryId: 2,
      walletId: 1,
      type: 'expense',
      id: 2,
      date: now,
      note: 'Sport Football',
      updateAt: now,
      createAt: now),
  TransactionModel(
      categoryModel: const CategoryModel(
          name: 'Wage, invoices', id: 1, icon: icWageInvoices, type: 'income'),
      balance: 23.5,
      categoryId: 1,
      walletId: 1,
      type: 'income',
      id: 3,
      date: now.subtract(const Duration(days: 3)),
      note: 'Transfer Vietcombank -> Cash',
      updateAt: now,
      createAt: now),
];

List<CategoryModel> categoriesDemo = const [
  CategoryModel(
    name: 'Food & Drinks',
    id: 1,
    icon: icFood,
    type: 'expense',
  ),
  CategoryModel(
    name: 'Shopping',
    id: 2,
    icon: icShopping,
    type: 'expense',
  ),
  CategoryModel(
    name: 'Housing',
    id: 3,
    icon: icHousing,
    type: 'expense',
  ),
  CategoryModel(
    name: 'Transportation',
    id: 4,
    icon: icTransportation,
    type: 'expense',
  ),
  CategoryModel(
    name: 'Life & Entertainment',
    id: 5,
    icon: icEntertainment,
    type: 'expense',
  ),
  CategoryModel(
    name: 'Financial Expenses',
    id: 6,
    icon: icFinancialExpenses,
    type: 'expense',
  ),
  CategoryModel(name: 'Income', id: 7, icon: icIncome, type: 'income'),
  CategoryModel(
      name: 'Groceries',
      id: 8,
      icon: icGroceries,
      type: 'expense',
      parrentId: 1),
  CategoryModel(
      name: 'Restaurant',
      id: 9,
      icon: icRestaurant,
      type: 'expense',
      parrentId: 1),
  CategoryModel(
      name: 'Bar, cafe', id: 10, icon: icBar, type: 'expense', parrentId: 1),
  CategoryModel(
      name: 'Clothes', id: 11, icon: icClothes, type: 'expense', parrentId: 2),
  CategoryModel(
      name: 'Health & beauty',
      id: 12,
      icon: icHealth,
      type: 'expense',
      parrentId: 2),
  CategoryModel(
      name: 'Kids', id: 13, icon: icKids, type: 'expense', parrentId: 2),
  CategoryModel(
      name: 'Pets', id: 14, icon: icPets, type: 'expense', parrentId: 2),
  CategoryModel(
      name: 'Home decor, funiture',
      id: 15,
      icon: icHomedecor,
      type: 'expense',
      parrentId: 2),
  CategoryModel(
      name: 'Electronics',
      id: 16,
      icon: icElectronics,
      type: 'expense',
      parrentId: 2),
  CategoryModel(
      name: 'Gifts, joy',
      id: 17,
      icon: icGiftsJoy,
      type: 'expense',
      parrentId: 2),
  CategoryModel(
      name: 'Drug-store, chemist',
      id: 18,
      icon: icDrugStore,
      type: 'expense',
      parrentId: 2),
  CategoryModel(
      name: 'Rent', id: 19, icon: icRent, type: 'expense', parrentId: 3),
  CategoryModel(
      name: 'Mortgage',
      id: 20,
      icon: icMortgage,
      type: 'expense',
      parrentId: 3),
  CategoryModel(
      name: 'Energy, utilities',
      id: 21,
      icon: icEnergy,
      type: 'expense',
      parrentId: 3),
  CategoryModel(
      name: 'Services',
      id: 22,
      icon: icServices,
      type: 'expense',
      parrentId: 3),
  CategoryModel(
      name: 'Maintain, repair',
      id: 23,
      icon: icMaintain,
      type: 'expense',
      parrentId: 3),
  CategoryModel(
      name: 'Public transport',
      id: 24,
      icon: icPublicTransport,
      type: 'expense',
      parrentId: 4),
  CategoryModel(
      name: 'Taxi', id: 25, icon: icTaxi, type: 'expense', parrentId: 4),
  CategoryModel(
      name: 'Long distance',
      id: 26,
      icon: icLongDistance,
      type: 'expense',
      parrentId: 4),
  CategoryModel(
      name: 'Fuel', id: 27, icon: icFuel, type: 'expense', parrentId: 4),
  CategoryModel(
      name: 'Parking', id: 28, icon: icParking, type: 'expense', parrentId: 4),
  CategoryModel(
      name: 'Vehicle maintain',
      id: 29,
      icon: icVehicleMaintain,
      type: 'expense',
      parrentId: 4),
  CategoryModel(
      name: 'Health care, doctor',
      id: 30,
      icon: icHealthCare,
      type: 'expense',
      parrentId: 5),
  CategoryModel(
      name: 'Wellness, beauty',
      id: 31,
      icon: icWellnessBeauty,
      type: 'expense',
      parrentId: 5),
  CategoryModel(
      name: 'Active sport, fitness',
      id: 32,
      icon: icActiveSport,
      type: 'expense',
      parrentId: 5),
  CategoryModel(
      name: 'Life events',
      id: 33,
      icon: icLifeEvents,
      type: 'expense',
      parrentId: 5),
  CategoryModel(
      name: 'Hobbies', id: 34, icon: icHobbies, type: 'expense', parrentId: 5),
  CategoryModel(
      name: 'Education',
      id: 35,
      icon: icEducation,
      type: 'expense',
      parrentId: 5),
  CategoryModel(
      name: 'Books, audio, subcriptions',
      id: 36,
      icon: icBooksAudio,
      type: 'expense',
      parrentId: 5),
  CategoryModel(
      name: 'Holiday, trips, hotel',
      id: 37,
      icon: icHolidayTrips,
      type: 'expense',
      parrentId: 5),
  CategoryModel(
      name: 'Charity, gifts',
      id: 38,
      icon: icCharityGifts,
      type: 'expense',
      parrentId: 5),
  CategoryModel(
      name: 'Lottery, gambling',
      id: 39,
      icon: icLotteryGamblingExpense,
      type: 'expense',
      parrentId: 5),
  CategoryModel(
      name: 'Taxes', id: 40, icon: icTaxes, type: 'expense', parrentId: 6),
  CategoryModel(
      name: 'Insurances',
      id: 41,
      icon: icInsurances,
      type: 'expense',
      parrentId: 6),
  CategoryModel(
      name: 'Loan, interest',
      id: 42,
      icon: icLoanInterest,
      type: 'expense',
      parrentId: 6),
  CategoryModel(
      name: 'Fines', id: 43, icon: icFines, type: 'expense', parrentId: 6),
  CategoryModel(
      name: 'Charges, fees',
      id: 44,
      icon: icChargesFees,
      type: 'expense',
      parrentId: 6),
  CategoryModel(
      name: 'Wage, invoices',
      id: 45,
      icon: icWageInvoices,
      type: 'income',
      parrentId: 7),
  CategoryModel(
      name: 'Sale', id: 46, icon: icSale, type: 'income', parrentId: 7),
  CategoryModel(
      name: 'Rental income',
      id: 47,
      icon: icRentalIncome,
      type: 'income',
      parrentId: 7),
  CategoryModel(
      name: 'Checks, coupon',
      id: 48,
      icon: icChecksCoupon,
      type: 'income',
      parrentId: 7),
  CategoryModel(
      name: 'Lottery, gambling',
      id: 49,
      icon: icLotteryGamblingIncome,
      type: 'income',
      parrentId: 7),
  CategoryModel(
      name: 'Refunds', id: 50, icon: icRefunds, type: 'income', parrentId: 7),
  CategoryModel(
      name: 'Gifts', id: 51, icon: icGifts, type: 'income', parrentId: 7),
];
