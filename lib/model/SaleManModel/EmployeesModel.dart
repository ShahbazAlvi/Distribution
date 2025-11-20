class EmployeesModel {
  final List<EmployeeData> data;

  EmployeesModel({required this.data});

  factory EmployeesModel.fromJson(List<dynamic> jsonList) {
    return EmployeesModel(
      data: jsonList.map((e) => EmployeeData.fromJson(e)).toList(),
    );
  }
}

class EmployeeData {
  final String id;
  final String? departmentName;
  final String employeeName;
  final String address;
  final String city;
  final String gender;
  final String mobile;
  final String nicNo;
  final String? dob; // ✅ DOB can be null
  final String? qualification;
  final String? bloodGroup;
  final bool isEnable;
  final bool? orderTacker;
  final int preBalance;
  final String createdAt;
  final String updatedAt;
  final int recoveryBalance;





  EmployeeData({
    required this.id,
    this.departmentName,
    required this.employeeName,
    required this.address,
    required this.city,
    required this.gender,
    required this.mobile,
    required this.nicNo,
    this.dob,
    this.qualification,
    this.bloodGroup,
    required this.isEnable,
    this.orderTacker,
    required this.preBalance,
    required this.createdAt,
    required this.updatedAt,
    required this.recoveryBalance,


  });

  factory EmployeeData.fromJson(Map<String, dynamic> json) {
    return EmployeeData(
      id: json["_id"] ?? "",
      departmentName: json["departmentName"],
      employeeName: json["employeeName"] ?? "",
      address: json["address"] ?? "",
      city: json["city"] ?? "",
      gender: json["gender"] ?? "",
      mobile: json["mobile"] ?? "",
      nicNo: json["nicNo"] ?? "",
      dob: json["dob"], // ✅ can be null
      qualification: json["qualification"],
      bloodGroup: json["bloodGroup"],
      isEnable: json["isEnable"] ?? false,
      orderTacker: json["OrderTacker"],
      preBalance: json["preBalance"] ?? 0,
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      recoveryBalance: json["recoveryBalance"] ?? 0,



    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "departmentName": departmentName,
      "employeeName": employeeName,
      "address": address,
      "city": city,
      "gender": gender,
      "mobile": mobile,
      "nicNo": nicNo,
      "dob": dob,
      "qualification": qualification,
      "bloodGroup": bloodGroup,
      "isEnable": isEnable,
      "OrderTacker": orderTacker,
      "preBalance": preBalance,
      "recoveryBalance":recoveryBalance,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
