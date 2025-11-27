import 'package:distribution/Screen/SalesView/SetUp/EmployeeDefine/updateScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Provider/SaleManProvider/SaleManProvider.dart';
import '../../../../compoents/AppColors.dart';
import '../../../../model/SaleManModel/EmployeesModel.dart';
import 'EmployeeAddScreen.dart';


class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<SaleManProvider>(context, listen: false).fetchEmployees());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SaleManProvider>(context);
    final allEmployees = provider.employees;

    /// ✅ Search filter
    final filteredEmployees = allEmployees.where((e) {
      return e.employeeName.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (e.departmentName ?? "").toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Center(
          child: Text(
            "Employee",
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
                provider.resetFields();
                Navigator.push(context,MaterialPageRoute(builder:(context)=>EmployeeAddScreen()));
              },
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              label: const Text(
                "Add Employee",
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

      body: Column(
        children: [
          // ✅ Search Bar
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search employee or department...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),

          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())

                : provider.error != null && provider.error!.isNotEmpty
                ? Center(
              child: Text(
                provider.error!,
                style: const TextStyle(color: Colors.red),
              ),
            )

                : filteredEmployees.isEmpty
                ? const Center(child: Text("No employees found"))

                : ListView.builder(
              itemCount: filteredEmployees.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                final EmployeeData emp = filteredEmployees[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),

                    title: Text(
                      emp.employeeName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Department: ${emp.departmentName ?? '-'}"),
                        Text("City: ${emp.city}"),
                        Text("Mobile: ${emp.mobile}"),
                        Text("CNIC: ${emp.nicNo}"),
                        Text("Recovery Balance: ${emp.recoveryBalance}"),
                      ],
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// ✅ Update Button
                        // IconButton(
                        //   icon: const Icon(Icons.edit, color: Colors.blue),
                        //   onPressed: () {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       const SnackBar(
                        //           content: Text("Update clicked")),
                        //     );
                        //   },
                        // ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmployeeUpdateScreen(employee: emp),
                              ),
                            );
                          },
                        ),


                        /// ✅ Delete Button
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red),
                          onPressed: () {
                            _confirmDelete(context, emp.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Delete Confirmation Dialog
  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Employee"),
        content: const Text("Are you sure you want to delete this employee?"),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.pop(context);

              Provider.of<SaleManProvider>(context, listen: false)
                  .deleteEmployee(id);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Deleted successfully")),
              );
            },
          ),
        ],
      ),
    );
  }
}
