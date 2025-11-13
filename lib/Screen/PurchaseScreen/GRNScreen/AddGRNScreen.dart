import 'dart:convert';
import 'package:distribution/compoents/AppColors.dart';
import 'package:distribution/compoents/SupplierDropdown.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddGRNScreen extends StatefulWidget {
  final String nextGrnId;
  const AddGRNScreen({super.key, required this.nextGrnId});

  @override
  State<AddGRNScreen> createState() => _AddGRNScreenState();
}

class _AddGRNScreenState extends State<AddGRNScreen> {
  late String currentDate;
  String? selectedSupplierId;
  Map<String, dynamic>? selectedSupplierDetails;

  final TextEditingController itemController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController rateController = TextEditingController();

  List<Map<String, dynamic>> productList = [];

  @override
  void initState() {
    super.initState();
    currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void addProduct() {
    if (itemController.text.isEmpty ||
        qtyController.text.isEmpty ||
        rateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please enter item, qty & rate")),
      );
      return;
    }

    final qty = double.tryParse(qtyController.text) ?? 0;
    final rate = double.tryParse(rateController.text) ?? 0;
    final total = qty * rate;

    setState(() {
      productList.add({
        "item": itemController.text,
        "qty": qty,
        "rate": rate,
        "total": total,
      });
    });

    itemController.clear();
    qtyController.clear();
    rateController.clear();
  }

  double get totalAmount {
    return productList.fold(0, (sum, item) => sum + item["total"]);
  }

  Future<void> saveGRN() async {
    if (selectedSupplierId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please select a supplier")),
      );
      return;
    }
    if (productList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please add at least one product")),
      );
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Token not found")),
        );
        return;
      }

      final url = Uri.parse("https://distribution-backend.vercel.app/api/grn");

      final body = {
        "grnDate": currentDate,
        "supplierId": selectedSupplierId,
        "products": productList,
        "totalAmount": totalAmount,
      };

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("✅ GRN ${widget.nextGrnId} saved successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed to save GRN: ${data["message"] ?? 'Error'}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Add New GRN",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 6,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.secondary, AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GRN Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("GRN ID: ${widget.nextGrnId}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 6),
                  Text("Date: $currentDate",
                      style: const TextStyle(fontSize: 16, color: Colors.black54)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Supplier Dropdown
            SupplierDropdown(
              selectedSupplierId: selectedSupplierId,
              onSelected: (id) {
                setState(() {
                  selectedSupplierId = id;
                  // Example: Fetch supplier details if available in your model
                  selectedSupplierDetails = {
                    "balance": 50000,
                    "address": "Industrial Area, Lahore",
                    "phone": "0300-1234567"
                  };
                });
              },
            ),

            if (selectedSupplierDetails != null) ...[
              const SizedBox(height: 10),
              Card(
                color: Colors.grey.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("📞 Phone: ${selectedSupplierDetails!["phone"]}"),
                      Text("🏠 Address: ${selectedSupplierDetails!["address"]}"),
                      Text("💰 Balance: ${selectedSupplierDetails!["balance"]}"),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Product Add Section
            const Text("Add Product", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),

            TextField(
              controller: itemController,
              decoration: const InputDecoration(
                labelText: "Item Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Quantity",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: rateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Rate",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Add Product"),
              onPressed: addProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size(double.infinity, 45),
              ),
            ),

            const SizedBox(height: 20),

            // Product List
            if (productList.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Added Products",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...productList.map((item) => Card(
                    child: ListTile(
                      title: Text(item["item"]),
                      subtitle: Text("Qty: ${item["qty"]}, Rate: ${item["rate"]}, Total: ${item["total"]}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() => productList.remove(item));
                        },
                      ),
                    ),
                  )),
                  const SizedBox(height: 10),
                  Text("Total Amount: $totalAmount",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green)),
                ],
              ),

            const SizedBox(height: 20),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Save GRN"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: saveGRN,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
