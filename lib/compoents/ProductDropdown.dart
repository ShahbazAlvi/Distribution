// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../Provider/ProductProvider/ProducProvider.dart';
// import '../model/ProductModel/ProductModel.dart';
// import 'AppColors.dart';
//
// class ProductDropdown extends StatefulWidget {
//   final Function(ProductModel) onProductSelected;
//
//   const ProductDropdown({super.key, required this.onProductSelected});
//
//   @override
//   State<ProductDropdown> createState() => _ProductDropdownState();
// }
//
// class _ProductDropdownState extends State<ProductDropdown> {
//   ProductModel? selectedProduct;
//
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() =>
//         Provider.of<ProductProvider>(context, listen: false).fetchProducts());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<ProductProvider>(context);
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Select Product",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 6),
//         provider.isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : DropdownButtonFormField<ProductModel>(
//           value: selectedProduct,
//           isExpanded: true,
//           hint: const Text("Choose Product"),
//           items: provider.products.map((product) {
//             return DropdownMenuItem<ProductModel>(
//               value: product,
//               child: Text("${product.itemName} (${product.itemUnit})"),
//             );
//           }).toList(),
//           onChanged: (value) {
//             setState(() {
//               selectedProduct = value;
//             });
//             if (value != null) widget.onProductSelected(value);
//           },
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: Colors.grey.shade100,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../model/ProductModel/itemsdetailsModel.dart';
import '../Provider/ProductProvider/ItemListsProvider.dart';


class ItemDetailsDropdown extends StatefulWidget {
  final Function(ItemDetails) onItemSelected;

  const ItemDetailsDropdown({super.key, required this.onItemSelected});

  @override
  State<ItemDetailsDropdown> createState() => _ItemDetailsDropdownState();
}

class _ItemDetailsDropdownState extends State<ItemDetailsDropdown> {
  ItemDetails? selectedItem;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ItemDetailsProvider>(context, listen: false).fetchItems());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemDetailsProvider>(context);

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
            : DropdownButtonFormField<ItemDetails>(
          value: selectedItem,
          isExpanded: true,
          hint: const Text("Choose Product"),
          items: provider.items.map((item) {
            return DropdownMenuItem<ItemDetails>(
              value: item,
              child: Row(
                children: [
                  // ✅ Product Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      item.itemImage.url,
                      height: 35,
                      width: 35,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),

                  // ✅ Name + Unit
                  Expanded(
                    child: Text(
                      "${item.itemName} (${item.itemUnit.unitName})",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedItem = value;
            });
            if (value != null) widget.onItemSelected(value);
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
