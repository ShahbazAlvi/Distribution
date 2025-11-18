import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/BankModel/ReceiptVoucher.dart';

class ReceiptVoucherProvider extends ChangeNotifier {
  bool isLoading = false;
  List<ReceiptVoucher> vouchers = [];
  bool isSubmitting= false;

  String baseUrl = "https://distribution-backend.vercel.app/api";
  String token = "";

  setToken(String t) {
    token = t;
  }

  /// 🔵 Fetch Receipt Vouchers
  Future<void> fetchVouchers() async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await http.get(
        Uri.parse("$baseUrl/receipt-vouchers"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        vouchers = (jsonData["data"] as List)
            .map((e) => ReceiptVoucher.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint("Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  /// 🔴 Delete Voucher
  Future<bool> deleteVoucher(String id) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/receipt-vouchers/$id"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        vouchers.removeWhere((item) => item.id == id);
        notifyListeners();
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }


  Future<bool> addVoucher({
    required String date,
    required String receiptId,
    required String bankId,
    required String salesmanId,
    required int amount,
    required String remarks,
  }) async {
    isSubmitting = true;
    notifyListeners();

    final url = "$baseUrl/receipt-vouchers";

    final body = {
      "date": date,
      "receiptId": receiptId,
      "bank": bankId,
      "salesman": salesmanId,
      "amountReceived": amount,
      "remarks": remarks,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    isSubmitting = false;
    notifyListeners();

    if (response.statusCode == 201) {
      fetchVouchers(); // refresh list
      return true;
    }

    return false;
  }

}
