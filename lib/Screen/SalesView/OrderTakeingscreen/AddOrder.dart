
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
import '../../../model/OrderTakingModel/OrderTakingModel.dart';
import '../../../model/ProductModel/itemsdetailsModel.dart';

class AddOrderScreen extends StatefulWidget {
  final String nextOrderId;
  final OrderData? existingOrder;
  final bool isUpdate;


  const AddOrderScreen({
    super.key,
    required this.nextOrderId,
    this.existingOrder,
    this.isUpdate = false,
  });

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  late String currentDate;
  bool isLoading = false;


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

    /// ✅ Pre-fill data when updating
    if (widget.isUpdate && widget.existingOrder != null) {
      final order = widget.existingOrder!;

      /// ✅ Load Salesman
      selectedSalesmanId = order.salesmanId?.id;

      /// ✅ Load Customer
      selectedCustomer = CustomerModel(
        id: order.customerId.id,
        customerName: order.customerId.customerName,
        address: order.customerId.address,
        phoneNumber: order.customerId.phoneNumber,
        creditTime: order.customerId.creditTime,
        salesBalance: order.customerId.salesBalance,
        timeLimit: order.customerId.timeLimit.toString(),
        formattedTimeLimit: order.customerId.timeLimit.toString(), // ✅ Added FIX
      );


      /// ✅ Load Products

      for (var p in order.products) {
        orderItems.add({
          "itemName": p.itemName,
          "qty": p.qty.toDouble(),
          "itemUnit": p.itemUnit,
          "rate": p.rate,
          "totalAmount": p.totalAmount,
        });
      }

    }

    Future.microtask(() {
      Provider.of<SaleManProvider>(context, listen: false).fetchSalesmen();
    });
  }

  void addProductToOrder() {
    if (selectedProduct != null && qtyController.text.isNotEmpty) {
      final qty = double.tryParse(qtyController.text) ?? 0;
      final total = selectedProduct!.price * qty;

      setState(() {
        orderItems.add({
          "product": selectedProduct!,
          "qty": qty,
          "total": total,
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
        title: const Text("Order Taking",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            )),
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

            /// ✅ Order ID & Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Order ID: ${widget.nextOrderId}"),
                Text("Date: $currentDate"),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),

            /// ✅ Salesman
            SalesmanDropdown(
              selectedId: selectedSalesmanId,
              onChanged: (value) {
                setState(() => selectedSalesmanId = value);
              },
            ),
            const SizedBox(height: 30),

            /// ✅ Customer
            CustomerDropdown(
              selectedCustomerId: selectedCustomer?.id,
              onChanged: (customer) {
                setState(() => selectedCustomer = customer);
              },
            ),
            const SizedBox(height: 20),

            /// ✅ Product Dropdown
            ItemDetailsDropdown(
              onItemSelected: (item) {
                setState(() => selectedProduct = item);
              },
            ),
            const SizedBox(height: 10),

            /// ✅ Product Quantity & Add button
            if (selectedProduct != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Purchase: ${selectedProduct!.purchase}"),
                  //Text("Price: ${selectedProduct!.price}"),
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
                  ),
                ],
              ),

            const SizedBox(height: 20),

            /// ✅ Product List
            if (orderItems.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Added Products",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...orderItems.map((item) {
                    final isNew = item.containsKey("product");
                    String itemName;
                    String unit;
                    double price;
                    double qty;
                    double total;
                    double purchase;

                    if (isNew) {
                      final product = item["product"] as ItemDetails;
                      itemName = product.itemName;
                      unit = product.itemUnit?.unitName ?? "";
                      price = item["price"] ?? product.price.toDouble(); // use local price if exists
                      qty = item["qty"];
                      total = item["total"];
                      purchase = product.purchase.toDouble();
                    } else {
                      itemName = item["itemName"];
                      unit = item["itemUnit"];
                      price = item["rate"].toDouble();
                      qty = item["qty"];
                      total = item["totalAmount"];
                      purchase = item["purchase"].toDouble();
                    }

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      color: Colors.grey[50],
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product name and delete icon
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  itemName,
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => setState(() => orderItems.remove(item)),
                                ),
                              ],
                            ),
                            Text("Purchase: $purchase"),
                            const SizedBox(height: 6),

                            // Unit & Editable Price
                            Row(
                              children: [
                                Chip(
                                  label: Text("Unit: $unit"),
                                  backgroundColor: Colors.blue[100],
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: 100,
                                  child: TextFormField(
                                    initialValue: price.toString(),
                                    keyboardType:
                                    const TextInputType.numberWithOptions(decimal: true),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                      border: OutlineInputBorder(),
                                      labelText: "Price",
                                    ),
                                    onChanged: (v) {
                                      setState(() {
                                        final newPrice = double.tryParse(v) ?? 0;
                                        price = newPrice;

                                        // Save editable price in orderItems map
                                        if (isNew) {
                                          item["price"] = newPrice; // ✅ store local editable price
                                        } else {
                                          item["rate"] = newPrice;
                                        }

                                        final newTotal = newPrice * qty;
                                        item["totalAmount"] = newTotal;
                                        item["total"] = newTotal;
                                        total = newTotal;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Quantity Input & Total
                            Row(
                              children: [
                                const Text("Qty: "),
                                SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    initialValue: qty.toString(),
                                    keyboardType:
                                    const TextInputType.numberWithOptions(decimal: true),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (v) {
                                      setState(() {
                                        final newQty = double.tryParse(v) ?? 0;
                                        qty = newQty;
                                        item["qty"] = newQty;

                                        final newTotal = newQty * price;
                                        item["totalAmount"] = newTotal;
                                        item["total"] = newTotal;
                                        total = newTotal;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  "Total: $total",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  })




                ],
              ),
            const SizedBox(height: 20),

            /// ✅ Final Button (Create/Update)

            // ElevatedButton(
            //   onPressed: () async {
            //
            //     // 🔥 Build final product list (works for new + update)
            //     final productList = orderItems.map((item) {
            //       bool isNew = item.containsKey("product");
            //
            //       String itemName;
            //       String unit;
            //       double qty;
            //       double rate;
            //       double total;
            //
            //       if (isNew) {
            //         // New items
            //         final p = item["product"] as ItemDetails;
            //
            //         itemName = p.itemName;
            //         unit = p.itemUnit?.unitName ?? "";
            //         qty = item["qty"];
            //         rate = item["price"] ?? p.price.toDouble();   // ← user-edited price
            //         total = item["total"];
            //       } else {
            //         // Updated OLD items
            //         itemName = item["itemName"];
            //         unit = item["itemUnit"];
            //         qty = item["qty"];
            //         rate = (item["rate"] as num).toDouble();
            //         total = item["totalAmount"];
            //       }
            //
            //       return {
            //         "itemName": itemName,
            //         "qty": qty,
            //         "itemUnit": unit,
            //         "rate": rate,
            //         "totalAmount": total,
            //       };
            //     }).toList();
            //
            //     // 🔥 Submit
            //     if (widget.isUpdate) {
            //       await orderProvider.updateOrder(
            //         widget.existingOrder!.id,
            //         {
            //           "salesmanId": selectedSalesmanId,
            //           "customerId": selectedCustomer!.id,
            //           "products": productList,
            //         },
            //       );
            //     } else {
            //       await orderProvider.createOrder(
            //         orderId: widget.nextOrderId,
            //         salesmanId: selectedSalesmanId!,
            //         customerId: selectedCustomer!.id,
            //         products: productList,
            //       );
            //     }
            //
            //     Navigator.pop(context);
            //   },
            //   child: Text(widget.isUpdate ? "Update Order" : "Create Order"),
            // ),
            ElevatedButton(
              onPressed: isLoading ? null : () async {
                if (selectedSalesmanId == null || selectedCustomer == null || orderItems.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields and add products")),
                  );
                  return;
                }

                setState(() => isLoading = true); // 🔥 start loading

                try {
                  final productList = orderItems.map((item) {
                    bool isNew = item.containsKey("product");

                    String itemName;
                    String unit;
                    double qty;
                    double rate;
                    double total;
                    int purchase;

                    if (isNew) {
                      final p = item["product"] as ItemDetails;
                      itemName = p.itemName;
                      unit = p.itemUnit?.unitName ?? "";
                      qty = item["qty"];
                      rate = item["price"] ?? p.price.toDouble();
                      total = item["total"];
                      purchase = item["purchase"] ?? 0;
                    } else {
                      itemName = item["itemName"];
                      unit = item["itemUnit"];
                      qty = item["qty"];
                      rate = (item["rate"] as num).toDouble();
                      total = item["totalAmount"];
                      purchase = item["purchase"] ?? 0;
                    }

                    return {
                      "itemName": itemName,
                      "qty": qty,
                      "itemUnit": unit,
                      "rate": rate,
                      "totalAmount": total,
                      "purchase": purchase,
                    };
                  }).toList();

                  if (widget.isUpdate) {
                    await orderProvider.updateOrder(
                      widget.existingOrder!.id,
                      {
                        "salesmanId": selectedSalesmanId,
                        "customerId": selectedCustomer!.id,
                        "products": productList,
                      },
                    );
                  } else {
                    await orderProvider.createOrder(
                      orderId: widget.nextOrderId,
                      salesmanId: selectedSalesmanId!,
                      customerId: selectedCustomer!.id,
                      products: productList,
                    );
                  }

                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e")),
                  );
                } finally {
                  setState(() => isLoading = false); // 🔥 stop loading
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: isLoading
                  ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : Text(widget.isUpdate ? "Update Order" : "Create Order"),
            ),


          ],
        ),
      ),
    );
  }
}
