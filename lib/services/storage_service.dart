import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/savings_model.dart';

class StorageService {
  static const String key = "savings_accounts";

  static Future<void> saveAccounts(
      List<SavingsModel> accounts) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> encodedList =
    accounts.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(key, encodedList);
  }

  static Future<List<SavingsModel>> loadAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? encodedList =
    prefs.getStringList(key);

    if (encodedList == null) return [];

    return encodedList
        .map((e) =>
        SavingsModel.fromJson(jsonDecode(e)))
        .toList();
  }
}