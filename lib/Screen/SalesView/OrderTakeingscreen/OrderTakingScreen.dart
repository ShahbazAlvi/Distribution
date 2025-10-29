
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Provider/OrderTakingProvider/OrderTakingProvider.dart';
import '../../../compoents/AppColors.dart';

class OrderTakingScreen extends StatefulWidget {
  const OrderTakingScreen({super.key});

  @override
  State<OrderTakingScreen> createState() => _OrderTakingScreenState();
}

class _OrderTakingScreenState extends State<OrderTakingScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<OrderTakingProvider>(context, listen: false)
            .FetchOrderTaking());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderTakingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child: const Text("Order Taking",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.2,
            )),
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
        actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => AddProductScreen()),
                  // );
                },
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                label: const Text(
                  "Add Order",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
          ? Center(child: Text(provider.error!))
          : provider.orderData == null
          ? const Center(child: Text("No data found"))
          : Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: provider.orderData!.data.length,
          itemBuilder: (context, index) {
            final order = provider.orderData!.data[index];
            final customer = order.customerId;
            final salesman =
                order.salesmanId?.employeeName ?? "N/A";
            final orderId = order.orderId;
            final date =
            order.date.toLocal().toString().split(' ')[0];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Top Row (Order ID + Date)
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Order ID: $orderId",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent
                                .withOpacity(0.1),
                            borderRadius:
                            BorderRadius.circular(8),
                          ),
                          child: Text(
                            date,
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    const Divider(),

                    // 🔹 Salesman / Customer Info
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text("Salesman: $salesman",
                                  style: const TextStyle(
                                      fontWeight:
                                      FontWeight.w500)),
                              const SizedBox(height: 4),
                              Text(
                                  "Customer: ${customer.customerName}"),
                              const SizedBox(height: 4),
                              Text("Phone: ${customer.phoneNumber}"),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // 🔹 Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content:
                                Text("Update action clicked"),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.background,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.edit, size: 18,color: AppColors.text),
                          label: const Text("Update",style: TextStyle(color: AppColors.text)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content:
                                Text("Delete action clicked"),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:AppColors.Instructions,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.delete, size: 18,color: AppColors.text,),
                          label:  Text("Delete",style: TextStyle(color: AppColors.text),),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.vertical(
                                    top:
                                    Radius.circular(20)),
                              ),
                              builder: (_) =>
                                  _OrderDetailsSheet(
                                      orderId: orderId),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.visibility,
                              size: 18,color: AppColors.text),
                          label: const Text("Details",style: TextStyle(color: AppColors.text)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OrderDetailsSheet extends StatelessWidget {
  final String orderId;
  const _OrderDetailsSheet({required this.orderId});

  @override
  Widget build(BuildContext context) {
    final provider =
    Provider.of<OrderTakingProvider>(context, listen: false);
    final order =
    provider.orderData!.data.firstWhere((o) => o.orderId == orderId);
    final customer = order.customerId;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Text("Order ID: ${order.orderId}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text("Date: ${order.date.toLocal().toString().split(' ')[0]}"),
            Text("Customer: ${customer.customerName}"),
            Text("Phone: ${customer.phoneNumber}"),
            Text("Address: ${customer.address}"),
            const Divider(),
            const Text("Products:",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            ...order.products.map((p) => ListTile(
              dense: true,
              title: Text(p.itemName),
              subtitle: Text("${p.qty} ${p.itemUnit} × ${p.rate}"),
              trailing: Text("Rs. ${p.totalAmount}"),
            )),
            const Divider(),
            Text("Status: ${order.status}",
                style: const TextStyle(color: Colors.blueAccent)),
          ],
        ),
      ),
    );
  }
}
