//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../Provider/Purchase_Provider/StockPositionProvider/StockPositionProvider.dart';
// import '../../../compoents/AppColors.dart';
// import '../../../model/Purchase_Model/StockPostionModel/StockPostionModel.dart';
//
// class StockPositionScreen extends StatelessWidget {
//   const StockPositionScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => StockPositionProvider()..fetchStockPosition(),
//       child: Scaffold(
//         appBar: AppBar(
//           iconTheme: const IconThemeData(color: Colors.white),
//           title: const Center(
//             child: Text(
//               "Stocks Position",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 22,
//                 letterSpacing: 1.2,
//               ),
//             ),
//           ),
//           centerTitle: true,
//           elevation: 6,
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [AppColors.secondary, AppColors.primary],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//           ),
//         ),
//         body: Consumer<StockPositionProvider>(
//           builder: (context, provider, child) {
//             if (provider.isLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }
//
//             if (provider.stockItems.isEmpty) {
//               return const Center(child: Text("No stock data found"));
//             }
//
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               scrollDirection: Axis.vertical,
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: DataTable(
//                   columns: const [
//                     DataColumn(
//                         label: Text(
//                           'S.No',
//                           style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                         )),
//                     DataColumn(
//                         label: Text(
//                           'Item Name',
//                           style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                         )),
//                     DataColumn(
//                         label: Text(
//                           'Stock',
//                           style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                         )),
//                   ],
//                   rows: provider.stockItems
//                       .asMap()
//                       .entries
//                       .map((entry) {
//                     int index = entry.key;
//                     StockPositionModel item = entry.value;
//                     return DataRow(
//                       cells: [
//                         DataCell(Text((index + 1).toString())), // S.No
//                         DataCell(Text(item.itemName ?? '-')),
//                         DataCell(Text((item.stock ?? 0).toString())),
//                       ],
//                     );
//                   })
//                       .toList(),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/Purchase_Provider/StockPositionProvider/StockPositionProvider.dart';
import '../../../compoents/AppColors.dart';
import '../../../model/Purchase_Model/StockPostionModel/StockPostionModel.dart';

class StockPositionScreen extends StatefulWidget {
  const StockPositionScreen({super.key});

  @override
  State<StockPositionScreen> createState() => _StockPositionScreenState();
}

class _StockPositionScreenState extends State<StockPositionScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StockPositionProvider()..fetchStockPosition(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Center(
            child: Text(
              "Stocks Position",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                letterSpacing: 1.2,
              ),
            ),
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

            // 🔍 Filter Items by search text
            List<StockPositionModel> filteredList = provider.stockItems
                .where((item) {
              final itemName = (item.itemName ?? "").toLowerCase();
              return itemName.contains(searchQuery.toLowerCase());
            }).toList();

            return Column(
              children: [
                // 🔍 Search Bar
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search by item name...",
                      prefixIcon: const Icon(Icons.search),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      // child: DataTable(
                      //   columns: const [
                      //     DataColumn(
                      //         label: Text(
                      //           'S.No',
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.bold, fontSize: 16),
                      //         )),
                      //     DataColumn(
                      //         label: Text(
                      //           'Item Name',
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.bold, fontSize: 16),
                      //         )),
                      //     DataColumn(
                      //         label: Text(
                      //           'Stock',
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.bold, fontSize: 16),
                      //         )),
                      //   ],
                      //   rows: filteredList
                      //       .asMap()
                      //       .entries
                      //       .map((entry) {
                      //     int index = entry.key;
                      //     StockPositionModel item = entry.value;
                      //     return DataRow(
                      //       cells: [
                      //         DataCell(Text((index + 1).toString())),
                      //         DataCell(Text(item.itemName ?? '-')),
                      //         DataCell(Text((item.stock ?? 0).toString())),
                      //       ],
                      //     );
                      //   }).toList(),
                      // ),
                       child:  DataTable(
                          columnSpacing: 20, // reduce space between columns
                          horizontalMargin: 10, // reduce left+right padding
                          columns: const [
                            DataColumn(
                              label: Text(
                                'S.No',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Item Name',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Stock',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ],
                          rows: filteredList.asMap().entries.map((entry) {
                            int index = entry.key;
                            StockPositionModel item = entry.value;

                            return DataRow(
                              cells: [
                                DataCell(Text((index + 1).toString())),
                                DataCell(Text(item.itemName?.trim() ?? '-')), // trim spaces
                                DataCell(Text((item.stock ?? 0).toString())),
                              ],
                            );
                          }).toList(),
                        )

                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
