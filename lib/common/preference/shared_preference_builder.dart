import 'dart:async';
import 'dart:convert';

import 'package:monsey/common/model/category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<CategoryModel?> getCategory({String input = 'category'}) async {
  final SharedPreferences shared = await SharedPreferences.getInstance();
  CategoryModel? categoryModel;
  if (shared.getString(input) != null) {
    final Map<String, dynamic> result = jsonDecode(shared.getString(input)!);
    categoryModel = CategoryModel.fromJson(result);
  }
  return categoryModel;
}

Future<void> setCategory(CategoryModel categoryModel) async {
  final SharedPreferences shared = await SharedPreferences.getInstance();
  shared.setString('category', jsonEncode(categoryModel.toJson()));
}

Future<void> removeCategory({String? key}) async {
  final SharedPreferences shared = await SharedPreferences.getInstance();
  shared.remove('category');
}

//save amount create transaction
Future<int> getAmountTransCreate({String input = 'amountTransaction'}) async {
  final SharedPreferences shared = await SharedPreferences.getInstance();
  final int amountCreate = shared.getInt(input) ?? 0;
  return amountCreate;
}

Future<void> setAmountTransCreate() async {
  final SharedPreferences shared = await SharedPreferences.getInstance();
  final int amountCreate = shared.getInt('amountTransaction') ?? 0;
  switch (amountCreate) {
    case 0:
      shared.setInt('amountTransaction', 1);
      break;
    case 1:
      shared.setInt('amountTransaction', 2);
      break;
    case 2:
      shared.setInt('amountTransaction', 0);
      break;
  }
}

Future<void> removeAmountTransCreate({String? key}) async {
  final SharedPreferences shared = await SharedPreferences.getInstance();
  shared.remove('amountTransaction');
}
