import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/CustomerProvider/CustomerProvider.dart';
import '../model/CustomerModel/CustomerModel.dart';

class CustomerDropdown extends StatefulWidget {
  final String? selectedCustomerId;
  final ValueChanged<CustomerModel?> onChanged;
  final String label;

  const CustomerDropdown({
    super.key,
    required this.onChanged,
    this.selectedCustomerId,
    this.label = "Select Customer",
  });

  @override
  State<CustomerDropdown> createState() => _CustomerDropdownState();
}

class _CustomerDropdownState extends State<CustomerDropdown> {
  CustomerModel? selectedCustomer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<CustomerProvider>(context, listen: false).fetchCustomer());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CustomerProvider>(context);

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null && provider.error!.isNotEmpty) {
      return Text(provider.error!, style: const TextStyle(color: Colors.red));
    }

    if (provider.customer.isEmpty) {
      return const Text("No customers found");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: widget.selectedCustomerId,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          hint: const Text("Choose Customer"),
          items: provider.customer.map((customer) {
            return DropdownMenuItem<String>(
              value: customer.id,
              child: Text(
                customer.customerName,
                style: const TextStyle(fontSize: 16),
              ),
            );
          }).toList(),
          onChanged: (id) {
            selectedCustomer = provider.customer.firstWhere(
                  (c) => c.id == id,
            );
            widget.onChanged(selectedCustomer);
          },
        ),

        const SizedBox(height: 16),

        if (selectedCustomer != null) _buildCustomerInfo(selectedCustomer!),
      ],
    );
  }

  Widget _buildCustomerInfo(CustomerModel customer) {
    return Card(

      elevation: double.infinity,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              customer.customerName,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text("📞 Phone: ${customer.phoneNumber}"),
            Text("🏠 Address: ${customer.address}"),
            Text("💰 Balance: ${customer.salesBalance.toStringAsFixed(2)}"),
            Text("🕓 Credit Days: ${customer.creditTime}"),
            Text("📅 Due Date: ${customer.formattedTimeLimit}"),
          ],
        ),
      ),
    );
  }
}
