import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Provider/BankProvider/BankListProvider.dart';
import '../../../../compoents/AppColors.dart';
import 'addBank.dart';



class BankListScreen extends StatefulWidget {
  const BankListScreen({super.key});

  @override
  State<BankListScreen> createState() => _BankListScreenState();
}

class _BankListScreenState extends State<BankListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<BankProvider>(context, listen: false).fetchBanks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Center(
          child: Text(
            "Banks List",
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
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddBankScreen()),
                );
              },
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              label: const Text(
                " Add Bank",
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

      body: Consumer<BankProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.bankList.isEmpty) {
            return const Center(child: Text("No banks found"));
          }

          return ListView.builder(
            itemCount: provider.bankList.length,
            itemBuilder: (context, index) {
              final bank = provider.bankList[index];

              return Card(
                margin: const EdgeInsets.all(12),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            bank.bankName,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),

                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  // navigate to update page
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  provider.deleteBank(bank.id);
                                },
                              ),
                            ],
                          )
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text("Account Holder: ${bank.accountHolderName}"),
                      Text("Account No: ${bank.accountNumber}"),

                      const SizedBox(height: 6),

                      Text(
                        "Balance: Rs. ${bank.balance}",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
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
