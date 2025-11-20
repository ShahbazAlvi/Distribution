import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../ApiLink/ApiEndpoint.dart';
import '../../model/ProductModel/ItemTypeModel.dart';


class ItemTypeProvider extends ChangeNotifier {
  List<ItemTypeModel> _itemTypes = [];
  bool loading = false;

  List<ItemTypeModel> get itemTypes => _itemTypes;

  Future<void> fetchItemTypes() async {
    loading = true;
    notifyListeners();

    final url = Uri.parse('${ApiEndpoints.baseUrl}/item-type');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer YOUR_TOKEN_HERE' // if required later
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          _itemTypes = data.map((e) => ItemTypeModel.fromJson(e)).toList();
        } else if (data['data'] != null) {
          _itemTypes = (data['data'] as List)
              .map((e) => ItemTypeModel.fromJson(e))
              .toList();
        }
      } else {
        debugPrint("Failed to load item types: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching item types: $e");
    }

    loading = false;
    notifyListeners();
  }

  Future<void> deleteItemType(String id) async {
    final url =
    Uri.parse('${ApiEndpoints.baseUrl}/item-type/$id');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        _itemTypes.removeWhere((item) => item.id == id);
        notifyListeners();
      } else {
        debugPrint("Failed to delete item: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Delete error: $e");
    }
  }
  Future<void> addItemType({
    required String categoryId,
    required String itemTypeName,
    required String token,
  }) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}/item-type');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'categoryId': categoryId,
          'itemTypeName': itemTypeName,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchItemTypes(); // Refresh list
        debugPrint('Item type added successfully');
      } else {
        debugPrint('Failed to add item type: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error adding item type: $e');
    }
  }

}
