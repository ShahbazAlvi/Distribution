
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
                      item.itemImage?.url ?? "",   // ✅ Safe null check
                      height: 35,
                      width: 35,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, _) => Container(
                        height: 35,
                        width: 35,
                        color: Colors.grey.shade100,
                        child: const Icon(Icons.image_not_supported, size: 18),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      "${item.itemName} (${item.itemUnit?.unitName ?? 'N/A'})",  // ✅ Safe
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
