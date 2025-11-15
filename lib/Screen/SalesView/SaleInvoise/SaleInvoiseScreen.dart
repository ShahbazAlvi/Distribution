import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Provider/OrderTakingProvider/OrderTakingProvider.dart';
import '../../../Provider/SaleInvoiceProvider/SaleInvoicesProvider.dart';
import '../../../compoents/AppColors.dart';
import '../../../compoents/SaleManDropdown.dart';

class SaleInvoiseScreen extends StatefulWidget {
  const SaleInvoiseScreen({super.key});

  @override
  State<SaleInvoiseScreen> createState() => _SaleInvoiseScreenState();
}

class _SaleInvoiseScreenState extends State<SaleInvoiseScreen> {
  String? selectedDate;
  String? selectedSalesmanId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<SaleInvoicesProvider>(context, listen: false).fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SaleInvoicesProvider>(context);

    final orders = provider.orderData?.data ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales Invoice",
            style: TextStyle(color: Colors.white, fontSize: 22)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
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

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // ✅ Date Picker
                GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );

                    if (picked != null) {
                      selectedDate = DateFormat('yyyy-MM-dd').format(picked);
                      setState(() {});

                      provider.fetchOrders(
                        date: selectedDate,
                        salesmanId: selectedSalesmanId,
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade200,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(selectedDate ?? "Select Date"),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ✅ Salesman Dropdown
                SalesmanDropdown(
                  selectedId: selectedSalesmanId,
                  onChanged: (value) {
                    selectedSalesmanId = value;
                    setState(() {});

                    provider.fetchOrders(
                      date: selectedDate,
                      salesmanId: selectedSalesmanId,
                    );
                  },
                ),
              ],
            ),
          ),

          // ✅ Loading
          if (provider.isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )

          // ✅ Error
          else if (provider.error != null)
            Expanded(
              child: Center(
                child: Text(provider.error!,
                    style: const TextStyle(color: Colors.red)),
              ),
            )

          // ✅ Order List
          else
            Expanded(
              child: orders.isEmpty
                  ? const Center(child: Text("No Orders Found"))
                  : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text("INV: ${order.orderId}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order.customerId.customerName),
                          Text(order.customerId.phoneNumber),
                          Text("Balance: ${order.customerId.salesBalance}"),
                          Text(order.salesmanId?.employeeName ??
                              "No Salesman"),
                        ],
                      ),
                      trailing: const Icon(Icons.receipt_long,
                          color: AppColors.secondary),
                      onTap: () {
                        showOrderDetailsSheet(context, order.orderId);
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void showOrderDetailsSheet(BuildContext context, String orderId) {
    final provider = Provider.of<SaleInvoicesProvider>(context, listen: false);
    final order = provider.orderData!.data.firstWhere((o) => o.orderId == orderId);

    // ✅ Controllers for each product
    List<TextEditingController> rateControllers = [];
    List<TextEditingController> qtyControllers = [];
    bool isUpdating = false;


    for (var p in order.products) {
      rateControllers.add(TextEditingController(text: p.rate.toString()));
      qtyControllers.add(TextEditingController(text: p.qty.toString()));
    }

    final discountCtrl = TextEditingController(text: "0");
    final receivedCtrl = TextEditingController(text: "0");

    DateTime deliveryDate = order.date;
    DateTime agingDate = order.date.add(const Duration(days: 5));

    double calcTotal() {
      double total = 0;
      for (int i = 0; i < order.products.length; i++) {
        final r = double.tryParse(rateControllers[i].text) ?? 0;
        final q = double.tryParse(qtyControllers[i].text) ?? 0;
        total += r * q;
      }
      return total;
    }

    double calcReceivable() => calcTotal() - (double.tryParse(discountCtrl.text) ?? 0);
    double calcBalance() => calcReceivable() - (double.tryParse(receivedCtrl.text) ?? 0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Edit Pending Order",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ✅ ORDER BASIC INFO
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Invoice No: ${order.orderId}",
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 4),

                          Text("Order Date: ${DateFormat('dd-MMM-yyyy').format(order.date)}"),

                          const SizedBox(height: 4),

                          Text("Customer: ${order.customerId.customerName}"),
                          Text("Phone: ${order.customerId.phoneNumber}"),

                          const SizedBox(height: 4),

                          Text("Salesman: ${order.salesmanId.employeeName}"),

                          const SizedBox(height: 10),

                          // ✅ Delivery Date Picker
                          Row(
                            children: [
                              const Text("Delivery Date: "),
                              GestureDetector(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: deliveryDate,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2035),
                                  );
                                  if (picked != null) {
                                    setState(() => deliveryDate = picked);
                                  }
                                },
                                child: Container(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(DateFormat('dd/MM/yyyy').format(deliveryDate)),
                                      const SizedBox(width: 6),
                                      const Icon(Icons.calendar_today, size: 18),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // ✅ Aging Date Picker
                          Row(
                            children: [
                              const Text("Aging Date: "),
                              GestureDetector(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: agingDate,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2035),
                                  );
                                  if (picked != null) {
                                    setState(() => agingDate = picked);
                                  }
                                },
                                child: Container(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(DateFormat('dd/MM/yyyy').format(agingDate)),
                                      const SizedBox(width: 6),
                                      const Icon(Icons.calendar_today, size: 18),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text("Items",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),

                    // ✅ YOUR EXISTING PRODUCT LIST (unchanged)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: order.products.length,
                      itemBuilder: (context, index) {
                        final item = order.products[index];
                        double rate =
                            double.tryParse(rateControllers[index].text) ?? 0;
                        double qty =
                            double.tryParse(qtyControllers[index].text) ?? 0;
                        double itemTotal = rate * qty;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.itemName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 10),

                              // ✅ Rate | Qty | Total Row
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: TextField(
                                      controller: rateControllers[index],
                                      decoration:
                                      const InputDecoration(labelText: "Rate"),
                                      keyboardType: TextInputType.number,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  const SizedBox(width: 10),

                                  Expanded(
                                    flex: 2,
                                    child: TextField(
                                      controller: qtyControllers[index],
                                      decoration:
                                      const InputDecoration(labelText: "Qty"),
                                      keyboardType: TextInputType.number,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 14),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey.shade400),
                                      ),
                                      child: Text(
                                        itemTotal.toStringAsFixed(2),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 10),
                    Text("Total Price: ${calcTotal().toStringAsFixed(2)}"),

                    TextField(
                      controller: discountCtrl,
                      decoration: const InputDecoration(labelText: "Discount"),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 10),

                    Text("Receivable: ${calcReceivable().toStringAsFixed(2)}"),

                    TextField(
                      controller: receivedCtrl,
                      decoration: const InputDecoration(labelText: "Received"),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                    ),

                    const SizedBox(height: 10),
                    Text("Balance: ${calcBalance().toStringAsFixed(2)}"),

                    const SizedBox(height: 20),


                    isUpdating
                        ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(),
                      ),
                    )
                        : ElevatedButton(
                      onPressed: () async {
                        setState(() => isUpdating = true);

                        List<Map<String, dynamic>> updatedProducts = [];

                        for (int i = 0; i < order.products.length; i++) {
                          updatedProducts.add({
                            "itemName": order.products[i].itemName,
                            "qty": int.parse(qtyControllers[i].text),
                            "itemUnit": order.products[i].itemUnit,
                            "rate": int.parse(rateControllers[i].text),
                            "totalAmount": int.parse(rateControllers[i].text) *
                                int.parse(qtyControllers[i].text),
                          });
                        }

                        await provider.createOrUpdateInvoice(
                          order: order,
                          products: updatedProducts,
                          discount: int.parse(discountCtrl.text),
                          received: int.parse(receivedCtrl.text),
                          deliveryDate: deliveryDate,
                          agingDate: agingDate,
                        );

                        setState(() => isUpdating = false);

                        Navigator.pop(context);
                        provider.fetchOrders();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text("Update Invoice", style: TextStyle(fontSize: 18)),
                    ),


                    const SizedBox(height: 20),
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
