import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/ProductModel/ItemCategoriesModel.dart';


class CategoriesProvider extends ChangeNotifier {
  List<CategoriesModel> _categories = [];
  bool loading = false;

  List<CategoriesModel> get categories => _categories;

  Future<void> fetchCategories() async {
    loading = true;
    notifyListeners();

    final url = Uri.parse('https://distribution-backend.vercel.app/api/categories');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_TOKEN_HERE', // Replace with actual token
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          _categories = data.map((e) => CategoriesModel.fromJson(e)).toList();
        } else if (data['data'] != null) {
          _categories = (data['data'] as List)
              .map((e) => CategoriesModel.fromJson(e))
              .toList();
        }
      } else {
        debugPrint("Failed: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }

    loading = false;
    notifyListeners();
  }

  Future<void> deleteCategory(String id) async {
    final url =
    Uri.parse('https://distribution-backend.vercel.app/api/categories/$id');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer YOUR_TOKEN_HERE',
        },
      );

      if (response.statusCode == 200) {
        _categories.removeWhere((item) => item.id == id);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Delete Error: $e");
    }
  }
  Future<void> addCategory(String name, String token) async {
    final url = Uri.parse('https://distribution-backend.vercel.app/api/categories');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'categoryName': name,
          'isEnable': true,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh categories after adding
        await fetchCategories();
      } else {
        debugPrint("Add category failed: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error adding category: $e");
    }
  }

}
