import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Provider/ProductProvider/ItemListsProvider.dart';
import '../../../../compoents/AppColors.dart';
import 'AddItem.dart';


class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ItemDetailsProvider>(context, listen: false)
            .fetchItems());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Center(
          child: Text(
            "Items lists",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.2,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child:ElevatedButton.icon(
              onPressed: () {
                final provider = Provider.of<ItemDetailsProvider>(context, listen: false);
                final nextItemId = provider.getNextItemId();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddItemScreen(nextItemId: nextItemId),
                  ),
                );
                Provider.of<ItemDetailsProvider>(context, listen: false).fetchItems();
              },
              icon: Icon(Icons.add_circle_outline, color: Colors.white),
              label: Text("Add Items", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            )

          ),
        ],
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
      body: Consumer<ItemDetailsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.items.isEmpty) {
            return const Center(child: Text("No items found"));
          }

          return ListView.builder(
            itemCount: provider.items.length,
            itemBuilder: (context, index) {
              final item = provider.items[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: item.itemImage != null && item.itemImage!.url.isNotEmpty
                      ? Image.network(
                    item.itemImage!.url,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    height: 50,
                    width: 50,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image_not_supported),
                  ),


                  title: Text(item.itemName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Text("Type: ${item.itemType?.itemTypeName}"),
                      Text("Category: ${item.itemCategory?.categoryName ?? 'N/A'}"),
                      Text("Purchase: ${item.purchase}"),
                     // Text("Price (Sales): ${item.price}"),
                      Text("Stock: ${item.stock}"),
                    ],
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ✅ Update Button
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Navigate to update page (you can create update screen)
                          // Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateItemScreen(item: item)));
                        },
                      ),

                      // ✅ Delete Button
                      // IconButton(
                      //   icon: const Icon(Icons.delete, color: Colors.red),
                      //   onPressed: () {
                      //     Provider.of<ItemDetailsProvider>(context,
                      //         listen: false)
                      //         .deleteItem(item.id);
                      //   },
                      // ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Delete Item"),
                                content: const Text("Are you sure you want to delete this item?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text("Yes", style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              );
                            },
                          );

                          // If user pressed Yes
                          if (confirm == true) {
                            Provider.of<ItemDetailsProvider>(context, listen: false)
                                .deleteItem(item.id);
                          }
                        },
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
}
