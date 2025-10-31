class CustomerData {
  final String id;
  final String customerName;
  final String email;
  final String? contactPerson;
  final String address;
  final String phoneNumber;
  final String mobileNumber;
  final String? designation;
  final String? ntn;
  final String? gst;
  final String paymentTerms;
  final int? creditLimit;
  final int creditTime;
  final String openingBalanceDate;
  final int? salesBalance;
  final int? purchaseBalance;
  final int? paidBalance;
  final bool isBank;
  final String status;
  final String? salesArea;
  final String createdAt;
  final String updatedAt;
  final String? timeLimit;
  final String? formattedTimeLimit;

  CustomerData({
    required this.id,
    required this.customerName,
    required this.email,
    this.contactPerson,
    required this.address,
    required this.phoneNumber,
    required this.mobileNumber,
    this.designation,
    this.ntn,
    this.gst,
    required this.paymentTerms,
    this.creditLimit,
    required this.creditTime,
    required this.openingBalanceDate,
    this.salesBalance,
    this.purchaseBalance,
    this.paidBalance,
    required this.isBank,
    required this.status,
    this.salesArea,
    required this.createdAt,
    required this.updatedAt,
    this.timeLimit,
    this.formattedTimeLimit,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      id: json['_id'] ?? "",
      customerName: json['customerName'] ?? "",
      email: json['email'] ?? "",
      contactPerson: json['contactPerson'],
      address: json['address'] ?? "",
      phoneNumber: json['phoneNumber'] ?? "",
      mobileNumber: json['mobileNumber'] ?? "",
      designation: json['designation'],
      ntn: json['ntn'],
      gst: json['gst'],
      paymentTerms: json['paymentTerms'] ?? "",
      creditLimit: json['creditLimit'],
      creditTime: json['creditTime'] ?? 0,
      openingBalanceDate: json['openingBalanceDate'] ?? "",
      salesBalance: json['salesBalance'],
      purchaseBalance: json['purchaseBalance'],
      paidBalance: json['paidBalance'],
      isBank: json['isBank'] ?? false,
      status: json['status'] ?? "",
      salesArea: json['salesArea'],
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      timeLimit: json['timeLimit'],
      formattedTimeLimit: json['formattedTimeLimit'],
    );
  }
}
