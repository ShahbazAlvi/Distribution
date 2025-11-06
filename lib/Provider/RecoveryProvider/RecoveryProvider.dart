import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/SaleRecoveryModel/SaleRecoveryModel.dart';



class RecoveryProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isUpdating = false;

  RecoverySaleModel? recoveryData;
  String token = "";

  String baseUrl = "https://distribution-backend.vercel.app/api";

  /// ✅ Load Token Automatically
  Future<void> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token") ?? "";
  }

  /// ✅ Fetch Recovery Report
  Future<void> fetchRecoveryReport(String salesmanId, String date) async {
    await loadToken(); // ✅ Auto load token

    try {
      isLoading = true;
      notifyListeners();

      final url = Uri.parse(
          "$baseUrl/sales-invoice/recovery-report?salesmanId=$salesmanId&recoveryDate=$date");

      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        recoveryData = RecoverySaleModel.fromJson(jsonDecode(response.body));
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Update Received Amount (PATCH)
  Future<bool> updateReceivedAmount(String invoiceId, String receivedAmount) async {
    await loadToken(); // ✅ Load token before API call

    try {
      isUpdating = true;
      notifyListeners();

      var url = Uri.parse("$baseUrl/sales-invoice/$invoiceId");

      var body = jsonEncode({
        "received": double.parse(receivedAmount),
      });

      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      isUpdating = false;
      notifyListeners();

      return response.statusCode == 200;
    } catch (e) {
      isUpdating = false;
      notifyListeners();
      return false;
    }
  }
}
