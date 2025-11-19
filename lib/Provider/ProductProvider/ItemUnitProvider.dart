import 'dart:convert';
import 'package:distribution/ApiLink/ApiEndpoint.dart';
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
        Uri.parse('${ApiEndpoints.baseUrl}/item-unit'),
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
        Uri.parse('${ApiEndpoints.baseUrl}/item-unit/$id'),
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
  Future<void> addItemUnit({
    required String unitName,
    required String description,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiEndpoints.baseUrl}/item-unit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "unitName": unitName,
          "description": description,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh the list after adding
        await fetchItemUnits();
      } else {
        debugPrint('Failed to add unit: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error adding unit: $e');
    }
  }

}
