import 'dart:convert';
import 'package:distribution/ApiLink/ApiEndpoint.dart';
import 'package:http/http.dart' as http;

import '../../../model/Purchase_Model/GNRModel/GNR_Model.dart';


class GRNApiService {
  static const String baseUrl = "YOUR_API_URL_HERE"; // Example: https://yourapi.com/api

  /// ✅ Fetch All GRN Records
  static Future<List<GRNModel>> fetchGRN() async {
    final response = await http.get(Uri.parse("${ApiEndpoints.baseUrl}/grn"));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return (body["data"] as List)
          .map((e) => GRNModel.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load GRN data");
    }
  }

  /// ✅ Delete GRN Record
  static Future<bool> deleteGRN(String id) async {
    final response = await http.delete(Uri.parse("$baseUrl/deleteGRN/$id"));

    return response.statusCode == 200;
  }
}
