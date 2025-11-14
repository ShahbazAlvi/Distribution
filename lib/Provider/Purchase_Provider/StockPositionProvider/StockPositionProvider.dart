import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../model/Purchase_Model/StockPostionModel/StockPostionModel.dart';


class StockPositionProvider extends ChangeNotifier {
  List<StockPositionModel> stockItems = [];
  bool isLoading = false;

  Future<void> fetchStockPosition() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://distribution-backend.vercel.app/api/item-details'),
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        stockItems = data.map((json) => StockPositionModel.fromJson(json)).toList();
      } else {
        stockItems = [];
      }
    } catch (e) {
      stockItems = [];
      print("Error fetching stock positions: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // int get totalStockValue =>
  //     stockItems.fold(0, (sum, item) => sum + item.totalAmount);
  double get totalStockValue => stockItems.fold(
    0,
        (sum, item) => sum + ((item.stock ?? 0) * (item.purchase ?? 0)),
  );

}
