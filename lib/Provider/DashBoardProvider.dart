import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart'as http;

import '../model/DashBoardModel.dart';

class DashBoardProvider with ChangeNotifier{

  Future<DashboardModel?> fetchDashboardData() async {
    try {
      final response = await http.get(
        Uri.parse('https://distribution-backend.vercel.app/api/dashboard/summary'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return DashboardModel.fromJson(jsonData);
      } else {
        print("Failed to load dashboard data: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching dashboard data: $e");
      return null;
    }
  }

}