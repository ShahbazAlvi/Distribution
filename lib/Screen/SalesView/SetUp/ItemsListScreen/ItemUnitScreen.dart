import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Provider/ProductProvider/ItemUnitProvider.dart';
import '../../../../compoents/AppColors.dart';
import '../../../../model/ProductModel/ItemUnitModel.dart';


class ItemUnitScreen extends StatefulWidget {
  const ItemUnitScreen({super.key});

  @override
  State<ItemUnitScreen> createState() => _ItemUnitScreenState();
}

class _ItemUnitScreenState extends State<ItemUnitScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ItemUnitProvider>(context, listen: false).fetchItemUnits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Center(
          child: Text(
            "Item Units",
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
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigator.push(context,MaterialPageRoute(builder:(context)=>AddCustomerScreen()));
              },
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              label: const Text(
                " Add item Units",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
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

      body: Consumer<ItemUnitProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.units.isEmpty) {
            return const Center(child: Text('No Units Found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: provider.units.length,
            itemBuilder: (context, index) {
              ItemUnitModel unit = provider.units[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(Icons.settings, color: Colors.blue),
                  ),
                  title: Text(
                    unit.unitName ?? "-",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(unit.description ?? "-"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color:AppColors.secondary),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Update ${unit.unitName} coming soon')),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          provider.deleteItemUnit(unit.id!);
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
