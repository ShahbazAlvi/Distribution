import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../model/Purchase_Model/SupplierLedgerModel/SupplierLedgerModel.dart';

class SuppliersLedgerProvider extends ChangeNotifier {
  List<SupplierLedgerData> ledgerData = [];
  bool loading = false;

  Future<void> fetchSupplierLedger(
      String supplierId, String from, String to) async {
    loading = true;
    ledgerData = [];
    notifyListeners();

    final url =
        "https://distribution-backend.vercel.app/api/supplier-ledger?supplier=$supplierId&from=$from&to=$to";

    final response = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer YOUR_TOKEN_HERE",
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final model = SupplierLedgerDetailModel.fromJson(jsonData);
      ledgerData = model.data;
    }

    loading = false;
    notifyListeners();
  }
}
