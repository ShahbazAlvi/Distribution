// class StockPositionModel {
//   final String? id;
//   final String? itemName;
//   final String? itemTypeName;
//   final String? categoryName;
//   final int? purchase;
//   final int? stock;
//   final int? price;
//
//   StockPositionModel({
//     this.id,
//     this.itemName,
//     this.itemTypeName,
//     this.categoryName,
//     this.purchase,
//     this.stock,
//     this.price,
//   });
//
//   factory StockPositionModel.fromJson(Map<String, dynamic> json) {
//     return StockPositionModel(
//       id: json["_id"] as String?,
//       itemName: json["itemName"] as String?,
//       itemTypeName: json["itemType"]?["itemTypeName"] as String?,
//       categoryName: json["itemCategory"]?["categoryName"] as String?,
//       purchase: json["purchase"] is int ? json["purchase"] : int.tryParse("${json["purchase"]}"),
//       stock: json["stock"] is int ? json["stock"] : int.tryParse("${json["stock"]}"),
//       price: json["price"] is int ? json["price"] : int.tryParse("${json["price"] ?? 0}"),
//     );
//   }
//
//   int get totalAmount => (stock ?? 0) * (price ?? 0);
// }
class StockPositionModel {
  final String? id;
  final String? itemName;
  final String? itemTypeName;
  final String? categoryName;
  final int? purchase;
  final int? stock;
  final int? price;

  StockPositionModel({
    this.id,
    this.itemName,
    this.itemTypeName,
    this.categoryName,
    this.purchase,
    this.stock,
    this.price,
  });

  factory StockPositionModel.fromJson(Map<String, dynamic> json) {
    // Safe int parser (never crashes)
    int? safeInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      return int.tryParse(value.toString());
    }

    return StockPositionModel(
      id: json["_id"]?.toString(),
      itemName: json["itemName"]?.toString(),

      itemTypeName: json["itemType"] is Map
          ? json["itemType"]["itemTypeName"]?.toString()
          : null,

      categoryName: json["itemCategory"] is Map
          ? json["itemCategory"]["categoryName"]?.toString()
          : null,

      purchase: safeInt(json["purchase"]),
      stock: safeInt(json["stock"]),
      price: safeInt(json["price"]),
    );
  }

  int get totalAmount => (stock ?? 0) * (price ?? 0);
}
