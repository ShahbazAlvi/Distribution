import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Provider/RecoveryProvider/RecoveryProvider.dart';
import '../../../compoents/SaleManDropdown.dart';
import '../../../model/SaleRecoveryModel/SaleRecoveryModel.dart';


class RecoveryListScreen extends StatefulWidget {
  const RecoveryListScreen({super.key});

  @override
  State<RecoveryListScreen> createState() => _RecoveryListScreenState();
}

class _RecoveryListScreenState extends State<RecoveryListScreen> {
  String? selectedDate;
  String? selectedSalesmanId;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecoveryProvider>(context);

    final records = provider.recoveryData?.data ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recovery Report",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // ✅ Date Picker
                GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );

                    if (picked != null) {
                      selectedDate = DateFormat('yyyy-MM-dd').format(picked);
                      setState(() {});

                      provider.fetchRecoveryReport(
                        selectedSalesmanId ?? "",
                        selectedDate ?? "",
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade200,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(selectedDate ?? "Select Date"),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ✅ Salesman Dropdown
                SalesmanDropdown(
                  selectedId: selectedSalesmanId,
                  onChanged: (value) {
                    selectedSalesmanId = value;
                    setState(() {});

                    provider.fetchRecoveryReport(
                      selectedSalesmanId ?? "",
                      selectedDate ?? "",
                    );
                  },
                ),
              ],
            ),
          ),

          // ✅ Loading
          if (provider.isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Expanded(
              child: records.isEmpty
                  ? const Center(child: Text("No Recovery Records Found"))
                  : ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final item = records[index];

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text("Invoice: ${item.id}"),
                      subtitle: Text("Customer: ${item.customer}\n"
                          "Balance: ${item.balance}"),
                      trailing: const Icon(Icons.edit, color: Colors.blue),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditRecoveryScreen(data: item),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}


class EditRecoveryScreen extends StatefulWidget {
  final RecoverySaleData data;

  const EditRecoveryScreen({
    super.key,
    required this.data,
  });

  @override
  State<EditRecoveryScreen> createState() => _EditRecoveryScreenState();
}

class _EditRecoveryScreenState extends State<EditRecoveryScreen> {
  final TextEditingController receivedController = TextEditingController();

  num balance = 0;

  @override
  void initState() {
    super.initState();
    balance = widget.data.balance ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecoveryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Recovery"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ✅ Recover Info Section
            _infoRow("Recovery Id", "null"),
            _infoRow("Recovery Date", widget.data.recoveryDate ?? ""),

            const SizedBox(height: 10),

            _infoRow("Invoice No.", widget.data.id ?? ""),
            _infoRow("Invoice Date", widget.data.date ?? ""),
            _infoRow("Customer", widget.data.customer ?? ""),
            _infoRow("Salesman", widget.data.salesman ?? ""),

            const SizedBox(height: 20),
            const Text(
              "Items",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _itemsTable(),

            const SizedBox(height: 20),

            _infoRow("Total Price", widget.data.total.toString()),
            _infoRow("Receivable", widget.data.total.toString()),

            const SizedBox(height: 8),

            // ✅ Enter Received Amount
            TextField(
              controller: receivedController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Received Amount",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) {
                final rec = double.tryParse(v) ?? 0;
                setState(() {
                  balance = (widget.data.total ?? 0) - rec;
                });
              },
            ),

            const SizedBox(height: 10),

            _infoRow("Balance", balance.toString()),

            const SizedBox(height: 25),

            provider.isUpdating
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                if (receivedController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Enter received amount")),
                  );
                  return;
                }

                bool ok = await provider.updateReceivedAmount(
                  widget.data.id!,                // invoice id
                  receivedController.text.trim(), // amount
                );

                if (ok) {
                  Navigator.pop(context);
                }
              },
              child: const Text(
                "Update Recovery",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ✅ Simple Row Widget
  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Text(value, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  // ✅ Item Table Widget
  Widget _itemsTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade400),
      children: [
         TableRow(children: [
          _tableHeader("SR#"),
          _tableHeader("ITEM"),
          _tableHeader("RATE"),
          _tableHeader("QTY"),
          _tableHeader("TOTAL"),
        ]),

        // ✅ Because Recovery API DOES NOT return product list,
        // we show a single-row invoice summary
        TableRow(children: [
          _tableCell(widget.data.sr.toString()),
          _tableCell(widget.data.customer ?? ""),
          _tableCell(widget.data.total.toString()),
          _tableCell("1"),
          _tableCell(widget.data.total.toString()),
        ]),
      ],
    );
  }

  // ✅ Helpers for Table
  static Widget _tableHeader(String text) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  static Widget _tableCell(String text) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}

