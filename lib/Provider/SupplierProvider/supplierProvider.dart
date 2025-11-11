import 'package:flutter/material.dart';

import '../../model/SupplierModel/SupplierModel.dart';
import 'Supplier_services.dart';

class SupplierProvider extends ChangeNotifier {
  List<SupplierModel> suppliers = [];
  bool isLoading = false;

  Future<void> loadSuppliers() async {
    isLoading = true;
    notifyListeners();

    try {
      suppliers = await SupplierApi.fetchSuppliers();
    } catch (e) {
      print("Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // Future<void> deleteSupplier(String id) async {
  //   bool success = await SupplierApi.deleteSupplier(id);
  //   if (success) {
  //     suppliers.removeWhere((e) => e.id == id);
  //     notifyListeners();
  //   }
  // }

  Future<void> updateSupplier({
    required String id,
    required String name,
    required String email,
    required String phone,
    required String address,
    required String paymentTerms,
  }) async {
    bool success = await SupplierApi.updateSupplier(
      id: id,
      name: name,
      email: email,
      phone: phone,
      address: address,
      paymentTerms: paymentTerms,
    );

    if (success) {
      int index = suppliers.indexWhere((e) => e.id == id);
      if (index != -1) {
        suppliers[index] = SupplierModel(
          id: id,
          supplierName: name,
          email: email,
          phoneNumber: phone,
          address: address,
          paymentTerms: paymentTerms,
          contactPerson: suppliers[index].contactPerson,
          mobileNumber: suppliers[index].mobileNumber,
          designation: suppliers[index].designation,
          ntn: suppliers[index].ntn,
          gst: suppliers[index].gst,
          creditLimit: suppliers[index].creditLimit,
          creditTime: suppliers[index].creditTime,
          status: suppliers[index].status,
          payableBalance: suppliers[index].payableBalance,
          createdAt: suppliers[index].createdAt,
          updatedAt: suppliers[index].updatedAt,
          invoiceNo: suppliers[index].invoiceNo,
          contactNumber: suppliers[index].contactNumber,
        );
      }
      notifyListeners();
    }
  }
}
