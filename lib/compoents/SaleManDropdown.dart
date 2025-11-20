//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../Provider/SaleManProvider/SaleManProvider.dart';
//
// class SalesmanDropdown extends StatefulWidget {
//   final String? selectedId;
//   final ValueChanged<String?> onChanged;
//   final String label;
//
//   const SalesmanDropdown({
//     super.key,
//     required this.onChanged,
//     this.selectedId,
//     this.label = "Select Salesman",
//   });
//
//   @override
//   State<SalesmanDropdown> createState() => _SalesmanDropdownState();
// }
//
// class _SalesmanDropdownState extends State<SalesmanDropdown> {
//   String? _selectedId;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedId = widget.selectedId;
//     Future.microtask(() =>
//         Provider.of<SaleManProvider>(context, listen: false).fetchEmployees());
//   }
//
//   @override
//   void didUpdateWidget(covariant SalesmanDropdown oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.selectedId != widget.selectedId) {
//       _selectedId = widget.selectedId;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<SaleManProvider>(context);
//
//     if (provider.isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     if (provider.error != null) {
//       return Text(provider.error!, style: const TextStyle(color: Colors.red));
//     }
//
//     if (provider.employees.isEmpty) {
//       return const Text("No employees found");
//     }
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.label,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         DropdownButtonFormField<String>(
//           isExpanded: true,
//           value: _selectedId,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: Colors.grey.shade100,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           hint: const Text("Choose Salesman"),
//           items: provider.employees.map((emp) {
//             return DropdownMenuItem<String>(
//               value: emp.id,
//               child: Text(emp.employeeName),
//             );
//           }).toList(),
//           onChanged: (value) {
//             setState(() => _selectedId = value);
//             widget.onChanged(value);
//           },
//         ),
//       ],
//     );
//   }
// }
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../Provider/SaleManProvider/SaleManProvider.dart';
//
// class SalesmanDropdown extends StatelessWidget {
//   final String? selectedId;
//   final ValueChanged<String?> onChanged;
//
//   const SalesmanDropdown({
//     super.key,
//     this.selectedId,
//     required this.onChanged,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<SaleManProvider>(context);
//
//     if (provider.isLoading) {
//       return const CircularProgressIndicator();
//     }
//
//     if (provider.error != null && provider.error!.isNotEmpty) {
//       return Text("Error: ${provider.error}");
//     }
//
//     return DropdownButton<String>(
//       value: selectedId,
//       isExpanded: true,
//       hint: const Text("Select Salesman"),
//       items: provider.employees.map((emp) {
//         return DropdownMenuItem<String>(
//           value: emp.id,
//           child: Text(emp.employeeName),
//         );
//       }).toList(),
//       onChanged: onChanged,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/SaleManProvider/SaleManProvider.dart';

class SalesmanDropdown extends StatelessWidget {
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  const SalesmanDropdown({
    super.key,
    this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SaleManProvider>(context);

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null && provider.error!.isNotEmpty) {
      return Text("Error: ${provider.error}");
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade300, // Background color
        border: Border.all(
          color: Colors.black,       // Border color
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedId,
          isExpanded: true,
          hint: const Text("Select Salesman"),
          items: provider.employees.map((emp) {
            return DropdownMenuItem<String>(
              value: emp.id,
              child: Text(emp.employeeName),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
