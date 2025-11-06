class RecoverySaleModel {
  bool? success;
  String? message;
  int? count;
  List<RecoverySaleData>? data;

  RecoverySaleModel({
    this.success,
    this.message,
    this.count,
    this.data,
  });

  factory RecoverySaleModel.fromJson(Map<String, dynamic> json) {
    return RecoverySaleModel(
      success: json['success'],
      message: json['message'],
      count: json['count'],
      data: json['data'] != null
          ? List<RecoverySaleData>.from(
          json['data'].map((x) => RecoverySaleData.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
      "count": count,
      "data": data != null
          ? List<dynamic>.from(data!.map((x) => x.toJson()))
          : [],
    };
  }
}

class RecoverySaleData {
  int? sr;
  String? date;
  String? id;
  String? customer;
  String? salesman;
  num? total;
  num? received;
  num? balance;
  int? billDays;
  int? dueDays;
  String? recoveryDate;

  RecoverySaleData({
    this.sr,
    this.date,
    this.id,
    this.customer,
    this.salesman,
    this.total,
    this.received,
    this.balance,
    this.billDays,
    this.dueDays,
    this.recoveryDate,
  });

  factory RecoverySaleData.fromJson(Map<String, dynamic> json) {
    return RecoverySaleData(
      sr: json['sr'],
      date: json['date'],
      id: json['id'],
      customer: json['customer'],
      salesman: json['salesman'],
      total: json['total'],
      received: json['received'],
      balance: json['balance'],
      billDays: json['billDays'],
      dueDays: json['dueDays'],
      recoveryDate: json['recoveryDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "sr": sr,
      "date": date,
      "id": id,
      "customer": customer,
      "salesman": salesman,
      "total": total,
      "received": received,
      "balance": balance,
      "billDays": billDays,
      "dueDays": dueDays,
      "recoveryDate": recoveryDate,
    };
  }
}
