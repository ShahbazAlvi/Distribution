import 'dart:convert';
import 'package:distribution/ApiLink/ApiEndpoint.dart';
import 'package:http/http.dart' as http;

import '../../model/SupplierModel/SupplierModel.dart';


class SupplierApi {
  static const String baseUrl = "YOUR_BASE_URL"; // example: https://yourapi.com/api

  /// ✅ Fetch Supplier List
  static Future<List<SupplierModel>> fetchSuppliers() async {
    final response = await http.get(Uri.parse("${ApiEndpoints.baseUrl}/suppliers"));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      print(body);
      return (body as List)
          .map((e) => SupplierModel.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load suppliers");
    }
  }

  /// ✅ Delete Supplier
  static Future<bool> deleteSupplier(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/deleteSupplier/$id"));
    return response.statusCode == 200;
  }

  /// ✅ Update Supplier
  static Future<bool> updateSupplier({
    required String id,
    required String name,
    required String email,
    required String phone,
    required String address,
    required String paymentTerms,
  }) async {
    final response = await http.put(
      Uri.parse("$baseUrl/updateSupplier/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "supplierName": name,
        "email": email,
        "phoneNumber": phone,
        "address": address,
        "paymentTerms": paymentTerms,
      }),
    );

    return response.statusCode == 200;
  }
}
