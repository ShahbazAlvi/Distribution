import 'dart:convert';

import 'package:distribution/ApiLink/ApiEndpoint.dart';
import 'package:flutter/cupertino.dart';

import '../../model/OrderTakingModel/OrderTakingModel.dart';
import 'package:http/http.dart'as http;

class OrderTakingProvider with ChangeNotifier{
  bool _isFetched = false;
  bool _isLoading = false;
  OrderTakingModel? _orderData;
  String? _error;

  // gets

  bool get isLoading => _isLoading;
  OrderTakingModel? get orderData => _orderData;
  String? get error => _error;


  Future<void>FetchOrderTaking()async{
    if(_isFetched)return;
    _isLoading=true;
    notifyListeners();
    try{
      final response =
      await http.get(Uri.parse('${ApiEndpoints.baseUrl}/order-taker'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _orderData = OrderTakingModel.fromJson(data);
        _isFetched = true;
      } else {
        _error = "Failed to load orders. (${response.statusCode})";
      }
      _isLoading = false;
      notifyListeners();

    }
    catch(e){
      _error = "Error refreshing: $e";

    }
  }
}