//
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// import '../../../Provider/OrderTakingProvider/OrderTakingProvider.dart';
// import '../../../Provider/SaleManProvider/SaleManProvider.dart';
// import '../../../compoents/AppColors.dart';
// import '../../../compoents/Customerdropdown.dart';
// import '../../../compoents/ProductDropdown.dart';
// import '../../../compoents/SaleManDropdown.dart';
// import '../../../model/CustomerModel/CustomerModel.dart';
// import '../../../model/OrderTakingModel/OrderTakingModel.dart';
// import '../../../model/ProductModel/itemsdetailsModel.dart';
//
// class AddOrderScreen extends StatefulWidget {
//   final String nextOrderId;
//   final OrderData? existingOrder;
//   final bool isUpdate;
//
//   const AddOrderScreen({super.key, required this.nextOrderId,this.existingOrder,
//     this.isUpdate = false,});
//
//   @override
//   State<AddOrderScreen> createState() => _AddOrderScreenState();
// }
//
// class _AddOrderScreenState extends State<AddOrderScreen> {
//   late String currentDate;
//   String? selectedSalesmanId;
//   CustomerModel? selectedCustomer;
//   ItemDetails? selectedProduct;
//
//   final TextEditingController qtyController = TextEditingController();
//   List<Map<String, dynamic>> orderItems = [];
//
//   @override
//   void dispose() {
//     qtyController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
//
//     if (widget.isUpdate && widget.existingOrder != null) {
//       final order = widget.existingOrder!;
//
//       selectedSalesmanId = order.salesmanId?.id;
//
//       selectedCustomer = CustomerModel(
//         id: order.customerId.id,
//         customerName: order.customerId.customerName,
//         address: order.customerId.address,
//         phoneNumber: order.customerId.phoneNumber,
//         creditTime: order.customerId.creditTime,   // ✅ REQUIRED
//       );
//
//
//
//       // ✅ Load products from existing order
//       for (var p in order.products) {
//         orderItems.add({
//           "product": ItemDetails(
//             itemName: p.itemName,
//             price: p.rate,
//             itemUnit: ItemUnit(id: "0", unitName: p.itemUnit),
//
//           ),
//           "qty": p.qty.toDouble(),
//           "total": p.totalAmount,
//         });
//       }
//     }
//
//     Future.microtask(() =>
//         Provider.of<SaleManProvider>(context, listen: false).fetchSalesmen());
//   }
//
//   void addProductToOrder() {
//     if (selectedProduct != null && qtyController.text.isNotEmpty) {
//       final qty = double.tryParse(qtyController.text) ?? 0;
//       final total = selectedProduct!.price * qty;
//
//       setState(() {
//         orderItems.add({
//           'product': selectedProduct!,
//           'qty': qty,
//           'total': total,
//         });
//       });
//
//       qtyController.clear();
//       selectedProduct = null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final orderProvider = Provider.of<OrderTakingProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Center(
//           child: Text(
//             "Order Taking",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 22,
//             ),
//           ),
//         ),
//         centerTitle: true,
//         elevation: 6,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [AppColors.secondary, AppColors.primary],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//
//             // ✅ Order ID + Date
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Order Id: ${widget.nextOrderId}'),
//                 Text("Date: $currentDate"),
//               ],
//             ),
//
//             const SizedBox(height: 20),
//             const Divider(),
//
//             // ✅ Salesman Dropdown
//             SalesmanDropdown(
//               selectedId: selectedSalesmanId,
//               onChanged: (value) {
//                 setState(() => selectedSalesmanId = value);
//               },
//             ),
//
//             const SizedBox(height: 30),
//
//             // ✅ Customer Dropdown
//             CustomerDropdown(
//               selectedCustomerId: selectedCustomer?.id,
//               onChanged: (customer) {
//                 setState(() => selectedCustomer = customer);
//               },
//             ),
//
//             const SizedBox(height: 20),
//
//             // ✅ Product Dropdown
//             ItemDetailsDropdown(
//               onItemSelected: (item) {
//                 setState(() => selectedProduct = item);
//               },
//             ),
//
//             const SizedBox(height: 10),
//
//             // ✅ Product Form after selection
//             if (selectedProduct != null)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Price: ${selectedProduct!.price}"),
//                   Text("Unit: ${selectedProduct!.itemUnit?.unitName}"),
//                   const SizedBox(height: 8),
//
//                   TextField(
//                     controller: qtyController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       labelText: "Enter Quantity",
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//
//                   const SizedBox(height: 8),
//
//                   ElevatedButton.icon(
//                     onPressed: addProductToOrder,
//                     icon: const Icon(Icons.add),
//                     label: const Text("Add Product"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.secondary,
//                     ),
//                   ),
//                 ],
//               ),
//
//             const SizedBox(height: 20),
//
//             // ✅ Added Products List
//             if (orderItems.isNotEmpty)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Added Products",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 10),
//
//                   // ...orderItems.map((item) {
//                   //   final product = item['product'] as ItemDetails;
//                   //
//                   //   return Card(
//                   //     margin: const EdgeInsets.symmetric(vertical: 4),
//                   //     child: ListTile(
//                   //       title: Text(product.itemName),
//                   //       subtitle: Text(
//                   //         "Qty: ${item['qty']} ${product.itemUnit?.unitName}\n"
//                   //             "Price: ${product.price}\n"
//                   //             "Total: ${item['total']}",
//                   //       ),
//                   //       trailing: IconButton(
//                   //         icon: const Icon(Icons.delete, color: Colors.red),
//                   //         onPressed: () {
//                   //           setState(() => orderItems.remove(item));
//                   //         },
//                   //       ),
//                   //     ),
//                   //   );
//                   // }),
//                   ...orderItems.map((item) {
//                     final product = item['product'] as ItemDetails;
//
//                     return Card(
//                       child: ListTile(
//                         title: Text(product.itemName),
//
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Unit: ${product.itemUnit?.unitName}"),
//                             Text("Price: ${product.price}"),
//
//                             Row(
//                               children: [
//                                 const Text("Qty: "),
//                                 SizedBox(
//                                   width: 60,
//                                   child: TextFormField(
//                                     initialValue: item['qty'].toString(),
//                                     keyboardType: TextInputType.number,
//                                     onChanged: (value) {
//                                       setState(() {
//                                         final newQty = double.tryParse(value) ?? 0;
//                                         item['qty'] = newQty;
//                                         item['total'] = newQty * product.price;
//                                       });
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//
//                         trailing: IconButton(
//                           icon: Icon(Icons.delete, color: Colors.red),
//                           onPressed: () {
//                             setState(() => orderItems.remove(item));
//                           },
//                         ),
//                       ),
//                     );
//                   })
//
//                 ],
//               ),
//
//             const SizedBox(height: 20),
//
//
//     // ElevatedButton(
//     // onPressed: orderProvider.isCreatingOrder
//     // ? null
//     //     : () async {
//     // if (selectedSalesmanId == null ||
//     // selectedCustomer == null ||
//     // orderItems.isEmpty) {
//     // ScaffoldMessenger.of(context).showSnackBar(
//     // const SnackBar(
//     // content: Text("Please fill all fields and add at least one product."),
//     // ),
//     // );
//     // return;
//     // }
//     //
//     // final productList = orderItems.map((item) {
//     // final product = item['product'] as ItemDetails;
//     // return {
//     // "itemName": product.itemName,
//     // "qty": item['qty'],
//     // "itemUnit": product.itemUnit?.unitName,
//     // "rate": product.price,
//     // "totalAmount": item['total'],
//     // };
//     // }).toList();
//     //
//     // await orderProvider.createOrder(
//     // orderId: widget.nextOrderId,
//     // salesmanId: selectedSalesmanId!,
//     // customerId: selectedCustomer!.id,
//     // products: productList,
//     // );
//     //
//     // if (!mounted) return;
//     //
//     // if (orderProvider.error == null) {
//     // ScaffoldMessenger.of(context).showSnackBar(
//     // const SnackBar(content: Text("✅ Order created successfully!")),
//     // );
//     // Navigator.pop(context);
//     // } else {
//     // ScaffoldMessenger.of(context).showSnackBar(
//     // SnackBar(content: Text(orderProvider.error!)),
//     // );
//     // }
//     // },
//     // style: ElevatedButton.styleFrom(
//     // backgroundColor: AppColors.secondary,
//     // padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//     // shape: RoundedRectangleBorder(
//     // borderRadius: BorderRadius.circular(10),
//     // ),
//     // ),
//     // child: orderProvider.isCreatingOrder
//     // ? const SizedBox(
//     // width: 26,
//     // height: 26,
//     // child: CircularProgressIndicator(
//     // strokeWidth: 2,
//     // color: Colors.white,
//     // ),
//     // )
//     //     : const Text(
//     // "Create Order",
//     // style: TextStyle(
//     // color: Colors.white,
//     // fontWeight: FontWeight.bold,
//     // ),
//     // ),
//     // )
//             ElevatedButton(
//               onPressed: () async {
//                 final productList = orderItems.map((item) {
//                   final product = item['product'] as ItemDetails;
//                   return {
//                     "itemName": product.itemName,
//                     "qty": item['qty'],
//                     "itemUnit": product.itemUnit?.unitName,
//                     "rate": product.price,
//                     "totalAmount": item['total'],
//                   };
//                 }).toList();
//
//                 if (widget.isUpdate) {
//                   await orderProvider.updateOrder(
//                     widget.existingOrder!.id,
//                     {
//                       "salesmanId": selectedSalesmanId,
//                       "customerId": selectedCustomer!.id,
//                       "products": productList,
//                     },
//                   );
//                 } else {
//                   await orderProvider.createOrder(
//                     orderId: widget.nextOrderId,
//                     salesmanId: selectedSalesmanId!,
//                     customerId: selectedCustomer!.id,
//                     products: productList,
//                   );
//                 }
//
//                 Navigator.pop(context);
//               },
//
//               child: Text(
//                 widget.isUpdate ? "Update Order" : "Create Order",
//               ),
//             )
//
//
//           ],
//         ),
//       ),
//     );
//   }
// }
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
      // for (var p in order.products) {
      //   orderItems.add({
      //     "product": ItemDetails(
      //       id: p.id,
      //       itemName: p.itemName,
      //       itemImage: "", // ✅ REQUIRED PARAM FIXED
      //       price: p.rate,
      //       itemUnit: ItemUnit(
      //         id: p.id,
      //         unitName: p.itemUnit,
      //       ),
      //     ),
      //     "qty": p.qty.toDouble(),
      //     "total": p.totalAmount,
      //   });
      // }
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
                    final isNew = item.containsKey("product"); // ✅ NEW order added product
                    String itemName;
                    String unit;
                    double price;
                    double qty;
                    double total;

                    if (isNew) {
                      // ✅ New order (ItemDetails object)
                      final product = item["product"] as ItemDetails;
                      itemName = product.itemName;
                      unit = product.itemUnit?.unitName ?? "";
                      price = product.price.toDouble();
                      qty = item["qty"];
                      total = item["total"];
                    } else {
                      // ✅ Update mode (simple map)
                      itemName = item["itemName"];
                      unit = item["itemUnit"];
                      price = item["rate"].toDouble();
                      qty = item["qty"];
                      total = item["totalAmount"];
                    }

                    return Card(
                      child: ListTile(
                        title: Text(itemName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Unit: $unit"),
                            Text("Price: $price"),
                            // ✅ SHOW TOTAL PRICE

                            Row(
                              children: [
                                const Text("Qty: "),
                                SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    initialValue: qty.toString(),
                                    keyboardType: TextInputType.number,
                                    onChanged: (v) {
                                      setState(() {
                                        final newQty = double.tryParse(v) ?? 0;
                                        item["qty"] = newQty;

                                        final newTotal = newQty * price;

                                        // ✅ Update correct keys
                                        item["totalAmount"] = newTotal;
                                        item["total"] = newTotal;

                                        // ✅ Update local variable so UI refreshes
                                        total = newTotal;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Text("Total: $total"),
                          ],
                        ),

                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() => orderItems.remove(item));
                          },
                        ),
                      ),
                    );
                  })

                ],
              ),
            const SizedBox(height: 20),

            /// ✅ Final Button (Create/Update)
            ElevatedButton(
              onPressed: () async {
                final productList = orderItems.map((item) {
                  final product = item["product"] as ItemDetails;
                  return {
                    "itemName": product.itemName,
                    "qty": item["qty"],
                    "itemUnit": product.itemUnit?.unitName,
                    "rate": product.price,
                    "totalAmount": item["total"],
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
              },
              child: Text(
                widget.isUpdate ? "Update Order" : "Create Order",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
