import 'dart:convert';
import 'package:distribution/ApiLink/ApiEndpoint.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/SaleManModel/SaleManModel.dart';

class SaleManProvider with ChangeNotifier {
  List<SaleManModel> _salesmen = [];
  bool _isLoading = false;
  String? _error;

  List<SaleManModel> get salesmen => _salesmen;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchSalesmen() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // ✅ Replace with your actual API URL
      final url = Uri.parse("${ApiEndpoints.baseUrl}/employees/orders");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        _salesmen = jsonList.map((e) => SaleManModel.fromJson(e)).toList();
      } else {
        _error = "Failed to load data: ${response.statusCode}";
      }
    } catch (e) {
      _error = "Error: $e";
    }

    _isLoading = false;
    notifyListeners();
  }
}
