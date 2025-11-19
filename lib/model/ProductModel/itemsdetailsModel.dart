
class ItemDetails {
  final ItemImage? itemImage;
  final String id;
  final String itemId;
  final ItemType? itemType;
  final ItemCategory? itemCategory;
  final String itemKind;
  final Manufacturer? manufacturer;
  final Supplier? supplier;
  final ShelveLocation? shelveLocation;
  final ItemUnit? itemUnit;
  final String itemName;
  final num purchase;
  final num price;
  final num stock;
  final num perUnit;
  final num reorder;
  final bool isEnable;
  final String primaryBarcode;
  final String secondaryBarcode;
  final bool noHasExpiray;
  final String createdAt;
  final String updatedAt;

  ItemDetails({
    required this.itemImage,
    required this.id,
    required this.itemId,
    required this.itemType,
    required this.itemCategory,
    required this.itemKind,
    required this.manufacturer,
    required this.supplier,
    required this.shelveLocation,
    required this.itemUnit,
    required this.itemName,
    required this.purchase,
    required this.price,
    required this.stock,
    required this.perUnit,
    required this.reorder,
    required this.isEnable,
    required this.primaryBarcode,
    required this.secondaryBarcode,
    required this.noHasExpiray,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItemDetails.fromJson(Map<String, dynamic> json) {
    num safeNum(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value;
      return num.tryParse(value.toString()) ?? 0;
    }

    return ItemDetails(
      itemImage: json["itemImage"] is Map
          ? ItemImage.fromJson(json["itemImage"])
          : null,

      id: json["_id"]?.toString() ?? "",
      itemId: json["itemId"]?.toString() ?? "",

      itemType: json["itemType"] is Map
          ? ItemType.fromJson(json["itemType"])
          : null,

      itemCategory: json["itemCategory"] is Map
          ? ItemCategory.fromJson(json["itemCategory"])
          : null,

      itemKind: json["itemKind"]?.toString() ?? "",

      manufacturer: json["manufacturer"] is Map
          ? Manufacturer.fromJson(json["manufacturer"])
          : null,

      supplier: json["supplier"] is Map
          ? Supplier.fromJson(json["supplier"])
          : null,

      shelveLocation: json["shelveLocation"] is Map
          ? ShelveLocation.fromJson(json["shelveLocation"])
          : null,

      itemUnit: json["itemUnit"] is Map
          ? ItemUnit.fromJson(json["itemUnit"])
          : null,

      itemName: json["itemName"]?.toString() ?? "",

      purchase: safeNum(json["purchase"]),
      price: safeNum(json["price"]),
      stock: safeNum(json["stock"]),
      perUnit: safeNum(json["perUnit"]),
      reorder: safeNum(json["reorder"]),

      isEnable: json["isEnable"] == true,

      primaryBarcode: json["primaryBarcode"]?.toString() ?? "",
      secondaryBarcode: json["secondaryBarcode"]?.toString() ?? "",
      noHasExpiray: json["noHasExpiray"] == true,

      createdAt: json["createdAt"]?.toString() ?? "",
      updatedAt: json["updatedAt"]?.toString() ?? "",
    );
  }
}
class ItemImage {
  final String url;
  final String publicId;

  ItemImage({required this.url, required this.publicId});

  factory ItemImage.fromJson(Map<String, dynamic> json) {
    return ItemImage(
      url: json["url"] ?? "",
      publicId: json["public_id"] ?? "",
    );
  }
}
class ItemType {
  final String id;
  final String itemTypeName;

  ItemType({required this.id, required this.itemTypeName});

  factory ItemType.fromJson(Map<String, dynamic> json) {
    return ItemType(
      id: json["_id"] ?? "",
      itemTypeName: json["itemTypeName"] ?? "",
    );
  }
}
class ItemCategory {
  final String id;
  final String categoryName;

  ItemCategory({required this.id, required this.categoryName});

  factory ItemCategory.fromJson(Map<String, dynamic> json) {
    return ItemCategory(
      id: json["_id"] ?? "",
      categoryName: json["categoryName"] ?? "",
    );
  }
}
class Manufacturer {
  final String id;
  final String manufacturerName;

  Manufacturer({required this.id, required this.manufacturerName});

  factory Manufacturer.fromJson(Map<String, dynamic> json) {
    return Manufacturer(
      id: json["_id"] ?? "",
      manufacturerName: json["manufacturerName"] ?? "",
    );
  }
}
class Supplier {
  final String id;
  final String supplierName;

  Supplier({required this.id, required this.supplierName});

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json["_id"] ?? "",
      supplierName: json["supplierName"] ?? "",
    );
  }
}
class ShelveLocation {
  final String id;
  final String shelfNameCode;

  ShelveLocation({required this.id, required this.shelfNameCode});

  factory ShelveLocation.fromJson(Map<String, dynamic> json) {
    return ShelveLocation(
      id: json["_id"] ?? "",
      shelfNameCode: json["shelfNameCode"] ?? "",
    );
  }
}
class ItemUnit {
  final String id;
  final String unitName;

  ItemUnit({required this.id, required this.unitName});

  factory ItemUnit.fromJson(Map<String, dynamic> json) {
    return ItemUnit(
      id: json["_id"] ?? "",
      unitName: json["unitName"] ?? "",
    );
  }
}
