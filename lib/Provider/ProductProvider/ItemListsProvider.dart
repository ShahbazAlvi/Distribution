import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/ProductModel/itemsdetailsModel.dart';


class ItemDetailsProvider with ChangeNotifier {
  List<ItemDetails> items = [];
  bool isLoading = false;

  String baseUrl = "https://distribution-backend.vercel.app/api/item-details";
  String token = "";   // ✅ Put your token here

  Future<void> fetchItems({String? categoryName, bool? isEnable}) async {
    try {
      isLoading = true;
      notifyListeners();

      final uri = Uri.parse(baseUrl);

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        items = data.map((e) => ItemDetails.fromJson(e)).toList();
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Fetch Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // ✅ Delete Item
  Future<void> deleteItem(String id) async {
    final uri =
    Uri.parse("https://distribution-backend.vercel.app/api/item-details/$id");

    try {
      final res = await http.delete(
        uri,
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        items.removeWhere((item) => item.id == id);
        notifyListeners();
      }
    } catch (e) {
      print("Delete error: $e");
    }
  }
}
