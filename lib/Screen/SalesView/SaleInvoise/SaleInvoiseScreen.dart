
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../Provider/OrderTakingProvider/OrderTakingProvider.dart';
import '../../../compoents/AppColors.dart';

class SaleInvoiseScreen extends StatefulWidget {
  const SaleInvoiseScreen({super.key});

  @override
  State<SaleInvoiseScreen> createState() => _SaleInvoiseScreenState();
}

class _SaleInvoiseScreenState extends State<SaleInvoiseScreen> {

  @override
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      Provider.of<OrderTakingProvider>(context, listen: false).FetchOrderTaking();
    });
  }


  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderTakingProvider>(context);

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.error != null) {
      return Scaffold(
        body: Center(child: Text(provider.error!)),
      );
    }

    final orders = provider.orderData?.data ?? [];

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Center(
          child: Text(
            "Sales Invoice",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
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
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text("INV: ${order.orderId}"),
                subtitle:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Text(order.customerId.customerName),
                    Text(order.customerId.phoneNumber),
                    Text("Balance: ${order.customerId.salesBalance}"),


                    Text(order.salesmanId!.employeeName),

                  ],
                ),

              trailing: const Icon(Icons.receipt_long,color: AppColors.secondary,),
              onTap: () {
                showOrderDetailsSheet(context, order.orderId);
              },
            ),
          );
        },
      ),
    );
  }

  // ✅ ✅ FULL UPDATED & WORKING BOTTOM SHEET FUNCTION
  void showOrderDetailsSheet(BuildContext context, String orderId) {
    final provider = Provider.of<OrderTakingProvider>(context, listen: false);
    final order =
    provider.orderData!.data.firstWhere((o) => o.orderId == orderId);
    final customer = order.customerId;
    final salesman = order.salesmanId;



    // ✅ Editable Products List
    List<Map<String, dynamic>> editableProducts = order.products.map((p) {
      return {
        "itemName": p.itemName,
        "qty": p.qty.toDouble(),
        "rate": p.rate.toDouble(),
        "total": (p.qty * p.rate).toDouble(),
        "itemUnit": p.itemUnit,
      };
    }).toList();

    final TextEditingController discountController =
    TextEditingController(text: "0");
    final TextEditingController receivedController =
    TextEditingController(text: "0");

    double calculateSubTotal() {
      return editableProducts.fold(
          0.0, (sum, item) => sum + item["total"]);
    }

    double calculateReceivable() {
      double discount = double.tryParse(discountController.text) ?? 0;
      return calculateSubTotal() - discount;
    }

    double calculateBalance() {
      double received = double.tryParse(receivedController.text) ?? 0;
      return calculateReceivable() - received;
    }

    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.85,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ✅ Sheet Header Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    // ✅ Order Details Header
                    Text("INV: ${order.orderId}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Date: ${order.date.toLocal().toString().split(' ')[0]}"),
                        Text("SalesMan: ${salesman!.employeeName}"),
                      ],
                    ),
                    Text("Customer: ${customer.customerName}"),
                    Text("Phone: ${customer.phoneNumber}"),
                    Text("Address: ${customer.address}"),

                    const Divider(),

                    // ✅ Editable Product List
                    const Text("Products (Editable):",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),

                    ...editableProducts.asMap().entries.map((entry) {
                      int index = entry.key;
                      var p = entry.value;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p["itemName"],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),

                              const SizedBox(height: 6),

                              Row(
                                children: [
                                  // ✅ Qty Editable
                                  Expanded(
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          labelText: "Qty"),
                                      onChanged: (val) {
                                        setState(() {
                                          p["qty"] = double.tryParse(val) ?? 0;
                                          p["total"] =
                                              p["qty"] * p["rate"];
                                        });
                                      },
                                      controller: TextEditingController(
                                          text: p["qty"].toString()),
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  // ✅ Rate Editable
                                  Expanded(
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          labelText: "Rate"),
                                      onChanged: (val) {
                                        setState(() {
                                          p["rate"] = double.tryParse(val) ?? 0;
                                          p["total"] =
                                              p["qty"] * p["rate"];
                                        });
                                      },
                                      controller: TextEditingController(
                                          text: p["rate"].toString()),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 4),
                              Text("Total: Rs ${p["total"]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                            ],
                          ),
                        ),
                      );
                    }),

                    const Divider(),

                    // ✅ Billing Summary
                    const Text("Billing Summary",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 8),

                    Text("Sub Total: Rs ${calculateSubTotal()}"),

                    const SizedBox(height: 5),

                    TextField(
                      controller: discountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: "Discount Amount",
                          border: OutlineInputBorder()),
                      onChanged: (_) => setState(() {}),
                    ),

                    const SizedBox(height: 8),

                    Text("Receivable: Rs ${calculateReceivable()}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),

                    const SizedBox(height: 8),

                    TextField(
                      controller: receivedController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: "Received Amount",
                          border: OutlineInputBorder()),
                      onChanged: (_) => setState(() {}),
                    ),

                    const SizedBox(height: 8),

                    Text("Balance: Rs ${calculateBalance()}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),

                    const SizedBox(height: 12),

                    Text(
                        "Delivery Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}"),

                    const SizedBox(height: 20),

                    // ✅ Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("SAVE"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
