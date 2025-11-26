import 'dart:convert';

import 'package:distribution/model/CustomerModel/CustomerModel.dart';
import 'package:distribution/model/CustomerModel/CustomersDefineModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../ApiLink/ApiEndpoint.dart';

class CustomerProvider with ChangeNotifier{
  List<CustomerModel>_customer=[];

  List<CustomerData> _customers = [];


  bool _isLoading=false;
  String? _error;

  // gets
List<CustomerModel> get customer=>_customer;
  List<CustomerData> get customers => _customers;
bool get isLoading=>_isLoading;
  String? get error => _error;



  final TextEditingController AreaNameController=TextEditingController();
  final TextEditingController CustomerNameController=TextEditingController();
  final TextEditingController ContactNumberController=TextEditingController();
  final TextEditingController AddressController=TextEditingController();
  final TextEditingController OpeningBalanceController=TextEditingController();
  final TextEditingController CreditDaysLimitController=TextEditingController();
  final TextEditingController CreditCashLimitController=TextEditingController();
  final TextEditingController dateController = TextEditingController();





  // Customer order Taking

  Future<void>fetchCustomer()async{
    _isLoading=true;
    _error='';
    notifyListeners();
    try{
      final url = Uri.parse("${ApiEndpoints.baseUrl}/customers/booking-customer");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        _customer = jsonList.map((e) => CustomerModel.fromJson(e)).toList();
      } else {
        _error = "Failed to load data: ${response.statusCode}";
      }

    }catch(e){
      _error = "Error: $e";

    }
    _isLoading = false;
    notifyListeners();
  }




  // CustomersDefine  setup

  Future<void>fetchCustomers()async{
    _isLoading=true;
    _error='';
    notifyListeners();
    try{
      final url = Uri.parse("${ApiEndpoints.baseUrl}/customers");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        _customers = jsonList.map((e) => CustomerData.fromJson(e)).toList();

      } else {
        _error = "Failed to load data: ${response.statusCode}";
      }

    }catch(e){
      _error = "Error: $e";

    }
    _isLoading = false;
    notifyListeners();
  }


  // get token sharePerference
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth_token");
    print("TOKEN => $token");

  }



  // Customers add
  Future<bool> addCustomer({
    required String salesmanId,
    required String paymentType,
    required String openingBalanceDate,
  }) async {

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      _error = "Token not found!";
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final url = Uri.parse("${ApiEndpoints.baseUrl}/customers");

    final body = {
      "salesArea": AreaNameController.text.trim(),
      "customerName": CustomerNameController.text.trim(),
      "address": AddressController.text.trim(),
      "phoneNumber": ContactNumberController.text.trim(),  // <-- fixed
      "openingBalanceDate": openingBalanceDate,
      "paymentTerms": paymentType == "credit" ? "Credit" : "Cash",
      "creditTime": int.tryParse(CreditDaysLimitController.text) ?? 0,
      "creditLimit": int.tryParse(CreditCashLimitController.text) ?? 0,
      "salesBalance": int.tryParse(OpeningBalanceController.text) ?? 0, // <-- matches backend
      "salesman": salesmanId,
    };

    print("SEND BODY => $body"); // DEBUG PRINT

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      print("API RESPONSE => ${response.body}"); // DEBUG PRINT

      if (response.statusCode == 201 || response.statusCode == 200) {
        clearForm();
        return true;
      } else {
        _error = "Failed: ${response.body}";
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }


  void clearForm() {
    AreaNameController.clear();
    CustomerNameController.clear();
    ContactNumberController.clear();
    AddressController.clear();
    OpeningBalanceController.clear();
    CreditDaysLimitController.clear();
    CreditCashLimitController.clear();
    dateController.clear();

    notifyListeners();
  }


  Future<void>DeleteCustomer(String idCustomer)async{
    try{
      _isLoading=true;
      notifyListeners();
      final prefs=await SharedPreferences.getInstance();
      final token=prefs.getString("token");

      final url = Uri.parse("${ApiEndpoints.baseUrl}/customers/$idCustomer");
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        debugPrint("✅ Order deleted successfully");

        _isLoading = false; // re-fetch
        await fetchCustomers();
      } else {
        _error = "Failed to delete: ${response.statusCode} - ${response.body}";
      }

    }catch (e) {
      _error = "Error deleting: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }

  }


  Future<bool> updateCustomer({
    required String id,
    required String salesmanId,
    required String paymentType,
    required String openingBalanceDate,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final url = Uri.parse("${ApiEndpoints.baseUrl}/customers/$id");

      final body = {
        "salesArea": AreaNameController.text,
        "customerName": CustomerNameController.text,
        "address": AddressController.text,
        "creditLimit": CreditCashLimitController.text,
        "creditTime": CreditDaysLimitController.text,
        "openingBalanceDate": openingBalanceDate,
        "paymentTerms": paymentType,
        "phoneNumber": ContactNumberController.text,
        "salesBalance": OpeningBalanceController.text,
        "salesman": salesmanId,
      };

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        return true;
      } else {
        _error = response.body;
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }



}
