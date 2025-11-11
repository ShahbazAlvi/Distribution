import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Provider/SupplierProvider/supplierProvider.dart';
import '../../../../compoents/AppColors.dart';


class SupplierListScreen extends StatefulWidget {
  const SupplierListScreen({super.key});

  @override
  State<SupplierListScreen> createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SupplierProvider>(context, listen: false).loadSuppliers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child: const Text("Supplier List",
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
      ),
      body: Consumer<SupplierProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: provider.suppliers.length,
            itemBuilder: (context, index) {
              final data = provider.suppliers[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(data.supplierName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email: ${data.email}"),
                      Text("Phone: ${data.phoneNumber}"),
                      Text("Address: ${data.address}"),
                      Text("Payment: ${data.paymentTerms}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ✅ Update
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showUpdateSheet(context, data),
                      ),

                      // ✅ Delete
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        // onPressed: () =>
                        //     provider.deleteSupplier(data.id),
                          onPressed: (){},
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// ✅ Update Bottom Sheet
  void _showUpdateSheet(context, supplier) {
    final provider = Provider.of<SupplierProvider>(context, listen: false);

    TextEditingController nameCtrl =
    TextEditingController(text: supplier.supplierName);
    TextEditingController emailCtrl =
    TextEditingController(text: supplier.email);
    TextEditingController phoneCtrl =
    TextEditingController(text: supplier.phoneNumber);
    TextEditingController addressCtrl =
    TextEditingController(text: supplier.address);
    TextEditingController paymentCtrl =
    TextEditingController(text: supplier.paymentTerms);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Update Supplier",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Supplier Name"),
              ),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: "Phone Number"),
              ),
              TextField(
                controller: addressCtrl,
                decoration: const InputDecoration(labelText: "Address"),
              ),
              TextField(
                controller: paymentCtrl,
                decoration: const InputDecoration(labelText: "Payment Terms"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  provider.updateSupplier(
                    id: supplier.id,
                    name: nameCtrl.text,
                    email: emailCtrl.text,
                    phone: phoneCtrl.text,
                    address: addressCtrl.text,
                    paymentTerms: paymentCtrl.text,
                  );

                  Navigator.pop(context);
                },
                child: const Text("Update"),
              )
            ],
          ),
        );
      },
    );
  }
}
