import 'package:flutter/material.dart';
import '../model/SupplierModel/SupplierModel.dart';

class SupplierDropdown extends StatelessWidget {
  final List<SupplierModel> suppliers;   // ✅ list from API
  final String? selectedSupplierId;      // ✅ selected value
  final Function(String) onSelected;     // ✅ return only supplier id

  const SupplierDropdown({
    super.key,
    required this.suppliers,
    required this.onSelected,
    this.selectedSupplierId,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Select Supplier",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),

      value: selectedSupplierId,

      items: suppliers.map((supplier) {
        return DropdownMenuItem<String>(
          value: supplier.id, // ✅ send only supplier ID
          child: Text(
            supplier.supplierName.isNotEmpty
                ? supplier.supplierName
                : "Unknown Supplier",
          ),
        );
      }).toList(),

      onChanged: (value) {
        if (value != null) {
          onSelected(value); // ✅ return ID to screen
        }
      },
    );
  }
}
