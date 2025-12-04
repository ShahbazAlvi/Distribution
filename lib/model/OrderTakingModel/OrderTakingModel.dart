class OrderTakingModel {
  final bool success;
  final int count;
  final List<OrderData> data;

  OrderTakingModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory OrderTakingModel.fromJson(Map<String, dynamic> json) {
    return OrderTakingModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => OrderData.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'count': count,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class OrderData {
  final String id;
  final String orderId;
  final DateTime date;
  final Salesman? salesmanId;
  //final Customer customerId;
  final Customer? customerId;
  final List<Product> products;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  OrderData({
    required this.id,
    required this.orderId,
    required this.date,
    this.salesmanId,
    //required this.customerId,
    this.customerId,
    required this.products,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['_id'] ?? '',
      orderId: json['orderId'] ?? '',
      date: DateTime.parse(json['date']),
      salesmanId: json['salesmanId'] != null
          ? Salesman.fromJson(json['salesmanId'])
          : null,
      // customerId: Customer.fromJson(json['customerId']),
      customerId: json['customerId'] != null     // <-- FIXED
          ? Customer.fromJson(json['customerId'])
          : null,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => Product.fromJson(e))
          .toList() ??
          [],
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'orderId': orderId,
    'date': date.toIso8601String(),
    'salesmanId': salesmanId?.toJson(),
    'customerId': customerId?.toJson(),
    'products': products.map((e) => e.toJson()).toList(),
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
  };
}

class Salesman {
  final String id;
  final String employeeName;

  Salesman({
    required this.id,
    required this.employeeName,
  });

  factory Salesman.fromJson(Map<String, dynamic> json) {
    return Salesman(
      id: json['_id'] ?? '',
      employeeName: json['employeeName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'employeeName': employeeName,
  };
}

class Customer {
  final String id;
  final String customerName;
  final String address;
  final String phoneNumber;
  final int creditTime;
  final double salesBalance;
  final DateTime? timeLimit;

  Customer({
    required this.id,
    required this.customerName,
    required this.address,
    required this.phoneNumber,
    required this.creditTime,
    required this.salesBalance,
    this.timeLimit,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id'] ?? '',
      customerName: json['customerName'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      creditTime: json['creditTime'] ?? 0,
      salesBalance: (json['salesBalance'] ?? 0).toDouble(),
     // timeLimit: DateTime.parse(json['timeLimit']),
      timeLimit: json['timeLimit'] != null   // ✅ FIXED
          ? DateTime.parse(json['timeLimit'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'customerName': customerName,
    'address': address,
    'phoneNumber': phoneNumber,
    'creditTime': creditTime,
    'salesBalance': salesBalance,
    'timeLimit': timeLimit?.toIso8601String(),

  };
}

class Product {
  final String? categoryName;
  final String itemName;
  final int qty;
  final String itemUnit;
  final double rate;
  final double totalAmount;
  final String id;

  Product({
    this.categoryName,
    required this.itemName,
    required this.qty,
    required this.itemUnit,
    required this.rate,
    required this.totalAmount,
    required this.id,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      categoryName: json['categoryName'],
      itemName: json['itemName'] ?? '',
      qty: json['qty'] ?? 0,
      itemUnit: json['itemUnit'] ?? '',
      rate: (json['rate'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'categoryName': categoryName,
    'itemName': itemName,
    'qty': qty,
    'itemUnit': itemUnit,
    'rate': rate,
    'totalAmount': totalAmount,
    '_id': id,
  };
}
