import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/ProductModel/ItemUnitModel.dart';


class ItemUnitProvider extends ChangeNotifier {
  List<ItemUnitModel> units = [];
  bool loading = false;

  Future<void> fetchItemUnits() async {
    loading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://distribution-backend.vercel.app/api/item-unit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer your_token_here', // optional if required
        },
      );

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        units = data.map((e) => ItemUnitModel.fromJson(e)).toList();
      } else {
        debugPrint("Failed to load item units: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error fetching item units: $e");
    }

    loading = false;
    notifyListeners();
  }

  Future<void> deleteItemUnit(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('https://distribution-backend.vercel.app/api/item-unit/$id'),
      );
      if (response.statusCode == 200) {
        units.removeWhere((u) => u.id == id);
        notifyListeners();
      } else {
        debugPrint('Delete failed: ${response.body}');
      }
    } catch (e) {
      debugPrint("Error deleting unit: $e");
    }
  }
}
