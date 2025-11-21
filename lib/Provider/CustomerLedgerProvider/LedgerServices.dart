import 'dart:convert';
import 'package:distribution/ApiLink/ApiEndpoint.dart';
import 'package:http/http.dart' as http;
import '../../model/CustomersLedger/CustomerLedger.dart';

class CustomerLedgerService {
  static const String baseUrl =
      "${ApiEndpoints.baseUrl}/customer-ledger";

  Future<CustomerLedgerDetailsModel?> fetchCustomerLedger({
    required String customerId,
    String? fromDate,
    String? toDate,
    required String token,
  }) async {

    String urlString = "$baseUrl?customer=$customerId";

    if (fromDate != null && toDate != null) {
      urlString += "&from=$fromDate&to=$toDate";
    }

    final url = Uri.parse(urlString);

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return CustomerLedgerDetailsModel.fromJson(json.decode(response.body));
    }

    throw Exception("Ledger error: ${response.body}");
  }

}
