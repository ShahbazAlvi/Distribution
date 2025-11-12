import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Provider/Purchase_Provider/PayaAmountProvider/PayaAmountProvider.dart';
import '../../../compoents/AppColors.dart';

class PayableAmountScreen extends StatefulWidget {
  const PayableAmountScreen({super.key});

  @override
  State<PayableAmountScreen> createState() => _PayableAmountScreenState();
}

class _PayableAmountScreenState extends State<PayableAmountScreen> {
  bool withZero = true; // default filter

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PayableAmountProvider>(context, listen: false)
          .fetchPayables(withZero: withZero);
    });
  }

  void _onFilterChanged(bool value) {
    setState(() => withZero = value);
    Provider.of<PayableAmountProvider>(context, listen: false)
        .fetchPayables(withZero: value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child: const Text("Payable Amount details",
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔘 Radio Filter
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Radio<bool>(
                      value: true,
                      groupValue: withZero,
                      onChanged: (val) => _onFilterChanged(val!),
                    ),
                    const Text("With Zero"),
                  ],
                ),
                const SizedBox(width: 20),
                Row(
                  children: [
                    Radio<bool>(
                      value: false,
                      groupValue: withZero,
                      onChanged: (val) => _onFilterChanged(val!),
                    ),
                    const Text("Without Zero"),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // 📋 Payables List
            Expanded(
              child: Consumer<PayableAmountProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.payables.isEmpty) {
                    return const Center(child: Text("No data found"));
                  }

                  return ListView(
                    children: [
                      ...provider.payables.map((p) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: 3,
                          child: ListTile(
                            title: Text(
                              p.supplier ?? "N/A",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text("Balance: ${p.balance?.toStringAsFixed(2)}"),
                            trailing: Text("SR: ${p.sr ?? "-"}"),
                          ),
                        );
                      }).toList(),

                      // 💰 Total Payable Card
                      Card(
                        color: Colors.grey[200],
                        margin: const EdgeInsets.only(top: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            "Total Payable: ${provider.totalPayable.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
