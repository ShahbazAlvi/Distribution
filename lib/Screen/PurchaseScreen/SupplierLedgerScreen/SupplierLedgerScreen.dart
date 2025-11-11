import 'package:distribution/model/SupplierModel/SupplierModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/Purchase_Provider/SupplierLedgerProvider/SupplierLedgerProvider.dart';
import '../../../Provider/SupplierProvider/supplierProvider.dart';
import '../../../compoents/AppColors.dart';
import '../../../compoents/SupplierDropdown.dart';

class SupplierLedgerScreen extends StatefulWidget {
  const SupplierLedgerScreen({super.key});

  @override
  State<SupplierLedgerScreen> createState() => _SupplierLedgerScreenState();
}

class _SupplierLedgerScreenState extends State<SupplierLedgerScreen> {
  String? selectedSupplierId;
  DateTime fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime toDate = DateTime.now();



  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<SupplierProvider>(context, listen: false).loadSuppliers();
    });
  }

  // ✅ Pick date method
  Future<void> pickDate({required bool isFrom}) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: isFrom ? fromDate : toDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (newDate != null) {
      setState(() {
        if (isFrom) {
          fromDate = newDate;
        } else {
          toDate = newDate;
        }
      });

      if (selectedSupplierId != null) {
        Provider.of<SuppliersLedgerProvider>(context, listen: false)
            .fetchSupplierLedger(
          selectedSupplierId!,
          fromDate.toIso8601String().substring(0, 10),
          toDate.toIso8601String().substring(0, 10),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final supplierProvider = Provider.of<SupplierProvider>(context);
    final ledgerProvider = Provider.of<SuppliersLedgerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Supplier Ledger"),

      ),

      body: Column(
        children: [


          // ✅ Date Filters Row
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => pickDate(isFrom: true),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text("From: ${fromDate.toString().substring(0, 10)}"),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => pickDate(isFrom: false),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8)),
                      child: Text("To: ${toDate.toString().substring(0, 10)}"),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ✅ Ledger List
          Expanded(
            child: ledgerProvider.loading
                ? const Center(child: CircularProgressIndicator())
                : ledgerProvider.ledgerData.isEmpty
                ? const Center(child: Text("No Records Found"))
                : ListView.builder(
              itemCount: ledgerProvider.ledgerData.length,
              itemBuilder: (context, index) {
                final item = ledgerProvider.ledgerData[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(item.description),
                    subtitle: Text("Date: ${item.date}"),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Paid: ${item.paid}"),
                        Text("Received: ${item.received}"),
                        Text("Balance: ${item.balance}"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
