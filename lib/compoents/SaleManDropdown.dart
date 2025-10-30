import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/SaleManProvider/SaleManProvider.dart';

class SalesmanDropdown extends StatefulWidget {
  final String? selectedId;
  final ValueChanged<String?> onChanged;
  final String label;

  const SalesmanDropdown({
    super.key,
    required this.onChanged,
    this.selectedId,
    this.label = "Select Salesman",
  });

  @override
  State<SalesmanDropdown> createState() => _SalesmanDropdownState();
}

class _SalesmanDropdownState extends State<SalesmanDropdown> {
  @override
  void initState() {
    super.initState();
    // Fetch the salesmen when component is first built
    Future.microtask(() =>
        Provider.of<SaleManProvider>(context, listen: false).fetchSalesmen());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SaleManProvider>(context);

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Text(provider.error!, style: const TextStyle(color: Colors.red));
    }

    if (provider.salesmen.isEmpty) {
      return const Text("No salesmen found");
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
          value: widget.selectedId,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          hint: const Text("Choose Salesman"),
          items: provider.salesmen.map((salesman) {
            return DropdownMenuItem<String>(
              value: salesman.id,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    salesman.employeeName,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}
