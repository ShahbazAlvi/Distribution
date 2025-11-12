import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/Purchase_Provider/StockPositionProvider/StockPositionProvider.dart';
import '../../../compoents/AppColors.dart';
import '../../../model/Purchase_Model/StockPostionModel/StockPostionModel.dart';


class StockPositionScreen extends StatelessWidget {
  const StockPositionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StockPositionProvider()..fetchStockPosition(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Center(child: const Text("Stocks Position",
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
        body: Consumer<StockPositionProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.stockItems.isEmpty) {
              return const Center(child: Text("No stock data found"));
            }

            return ListView(
              padding: const EdgeInsets.all(12),
              children: [
                ...provider.stockItems.map((StockPositionModel item) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Item: ${item.itemName ?? '-'}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text("Category: ${item.categoryName ?? '-'}"),
                          Text("Type: ${item.itemTypeName ?? '-'}"),
                          Text("Purchase: ${item.purchase ?? 0}"),
                          Text("Stock: ${item.stock ?? 0}"),
                          Text("Price: ${item.price ?? 0}"),
                          Text("Total Amount: ${item.totalAmount}"),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 8),
                Card(
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "Total Stock Value: ${provider.totalStockValue}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
