
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Provider/OrderTakingProvider/OrderTakingProvider.dart';
import '../../../Provider/SaleManProvider/SaleManProvider.dart';
import '../../../compoents/AppColors.dart';
import '../../../compoents/Customerdropdown.dart';
import '../../../compoents/ProductDropdown.dart';
import '../../../compoents/SaleManDropdown.dart';
import '../../../model/CustomerModel/CustomerModel.dart';
import '../../../model/ProductModel/itemsdetailsModel.dart';

class AddOrderScreen extends StatefulWidget {
  final String nextOrderId;
  const AddOrderScreen({super.key, required this.nextOrderId});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  late String currentDate;
  String? selectedSalesmanId;
  CustomerModel? selectedCustomer;
  ItemDetails? selectedProduct;

  final TextEditingController qtyController = TextEditingController();
  List<Map<String, dynamic>> orderItems = [];

  @override
  void dispose() {
    qtyController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    Future.microtask(() =>
        Provider.of<SaleManProvider>(context, listen: false).fetchSalesmen());
  }

  void addProductToOrder() {
    if (selectedProduct != null && qtyController.text.isNotEmpty) {
      final qty = double.tryParse(qtyController.text) ?? 0;
      final total = selectedProduct!.price * qty;

      setState(() {
        orderItems.add({
          'product': selectedProduct!,
          'qty': qty,
          'total': total,
        });
      });

      qtyController.clear();
      selectedProduct = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderTakingProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Center(
          child: Text(
            "Order Taking",
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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // ✅ Order ID + Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order Id: ${widget.nextOrderId}'),
                Text("Date: $currentDate"),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(),

            // ✅ Salesman Dropdown
            SalesmanDropdown(
              selectedId: selectedSalesmanId,
              onChanged: (value) {
                setState(() => selectedSalesmanId = value);
              },
            ),

            const SizedBox(height: 30),

            // ✅ Customer Dropdown
            CustomerDropdown(
              selectedCustomerId: selectedCustomer?.id,
              onChanged: (customer) {
                setState(() => selectedCustomer = customer);
              },
            ),

            const SizedBox(height: 20),

            // ✅ Product Dropdown
            ItemDetailsDropdown(
              onItemSelected: (item) {
                setState(() => selectedProduct = item);
              },
            ),

            const SizedBox(height: 10),

            // ✅ Product Form after selection
            if (selectedProduct != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Price: ${selectedProduct!.price}"),
                  Text("Unit: ${selectedProduct!.itemUnit?.unitName}"),
                  const SizedBox(height: 8),

                  TextField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Enter Quantity",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 8),

                  ElevatedButton.icon(
                    onPressed: addProductToOrder,
                    icon: const Icon(Icons.add),
                    label: const Text("Add Product"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            // ✅ Added Products List
            if (orderItems.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Added Products",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  ...orderItems.map((item) {
                    final product = item['product'] as ItemDetails;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        title: Text(product.itemName),
                        subtitle: Text(
                          "Qty: ${item['qty']} ${product.itemUnit?.unitName}\n"
                              "Price: ${product.price}\n"
                              "Total: ${item['total']}",
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() => orderItems.remove(item));
                          },
                        ),
                      ),
                    );
                  }),
                ],
              ),

            const SizedBox(height: 20),


    ElevatedButton(
    onPressed: orderProvider.isCreatingOrder
    ? null
        : () async {
    if (selectedSalesmanId == null ||
    selectedCustomer == null ||
    orderItems.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
    content: Text("Please fill all fields and add at least one product."),
    ),
    );
    return;
    }

    final productList = orderItems.map((item) {
    final product = item['product'] as ItemDetails;
    return {
    "itemName": product.itemName,
    "qty": item['qty'],
    "itemUnit": product.itemUnit?.unitName,
    "rate": product.price,
    "totalAmount": item['total'],
    };
    }).toList();

    await orderProvider.createOrder(
    orderId: widget.nextOrderId,
    salesmanId: selectedSalesmanId!,
    customerId: selectedCustomer!.id,
    products: productList,
    );

    if (!mounted) return;

    if (orderProvider.error == null) {
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("✅ Order created successfully!")),
    );
    Navigator.pop(context);
    } else {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(orderProvider.error!)),
    );
    }
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.secondary,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
    ),
    ),
    child: orderProvider.isCreatingOrder
    ? const SizedBox(
    width: 26,
    height: 26,
    child: CircularProgressIndicator(
    strokeWidth: 2,
    color: Colors.white,
    ),
    )
        : const Text(
    "Create Order",
    style: TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    ),
    ),
    )

    ],
        ),
      ),
    );
  }
}
