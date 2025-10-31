import 'dart:convert';
import 'package:distribution/ApiLink/ApiEndpoint.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/SaleManModel/EmployeesModel.dart';
import '../../model/SaleManModel/SaleManModel.dart';

class SaleManProvider with ChangeNotifier {
  List<SaleManModel> _salesmen = [];
  List<EmployeeData> _employees = [];
  bool _isLoading = false;
  String? _error;

  List<SaleManModel> get salesmen => _salesmen;
  List<EmployeeData>get employees=>_employees;
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

  Future<void> fetchEmployees() async {
    _isLoading = true;
    _error = "";
    notifyListeners();

    try {
      final url = Uri.parse("${ApiEndpoints.baseUrl}/employees");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);

        _employees = jsonList.map((e) => EmployeeData.fromJson(e)).toList();
      } else {
        _error = "Error Code: ${response.statusCode}";
      }
    } catch (e) {
      _error = "Error: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  /// ✅ Delete (You can plug API later)
  Future<void> deleteEmployee(String id) async {
    _employees.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
