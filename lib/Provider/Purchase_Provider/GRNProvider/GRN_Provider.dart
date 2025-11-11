import 'package:flutter/material.dart';

import '../../../model/Purchase_Model/GNRModel/GNR_Model.dart';
import 'GRN_services.dart';

class GRNProvider extends ChangeNotifier {
  List<GRNModel> grnList = [];
  bool isLoading = false;

  Future<void> getGRNData() async {
    isLoading = true;
    notifyListeners();

    try {
      grnList = await GRNApiService.fetchGRN();
    } catch (e) {
      print("Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteRecord(String id) async {
    bool success = await GRNApiService.deleteGRN(id);
    if (success) {
      grnList.removeWhere((item) => item.id == id);
      notifyListeners();
    }
  }
}
