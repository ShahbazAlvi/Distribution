import 'dart:convert';

import 'package:distribution/model/CustomerModel/CustomerModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;

import '../../ApiLink/ApiEndpoint.dart';

class CustomerProvider with ChangeNotifier{
  List<CustomerModel>_customer=[];
  bool _isLoading=false;
  String? _error;

  // gets
List<CustomerModel> get customer=>_customer;
bool get isLoading=>_isLoading;
  String? get error => _error;


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
}
