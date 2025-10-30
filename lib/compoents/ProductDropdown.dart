import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/ProductProvider/ProducProvider.dart';
import '../model/ProductModel/ProductModel.dart';
import 'AppColors.dart';

class ProductDropdown extends StatefulWidget {
  final Function(ProductModel) onProductSelected;

  const ProductDropdown({super.key, required this.onProductSelected});

  @override
  State<ProductDropdown> createState() => _ProductDropdownState();
}

class _ProductDropdownState extends State<ProductDropdown> {
  ProductModel? selectedProduct;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ProductProvider>(context, listen: false).fetchProducts());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Product",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : DropdownButtonFormField<ProductModel>(
          value: selectedProduct,
          isExpanded: true,
          hint: const Text("Choose Product"),
          items: provider.products.map((product) {
            return DropdownMenuItem<ProductModel>(
              value: product,
              child: Text("${product.itemName} (${product.itemUnit})"),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedProduct = value;
            });
            if (value != null) widget.onProductSelected(value);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
