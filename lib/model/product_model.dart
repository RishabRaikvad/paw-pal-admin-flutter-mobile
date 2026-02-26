
class ProductModel {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final String categoryName;

  final String mainProductImage;
  final List<String> images;

  final bool isActive;
  final List<ProductVariant> variants;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.categoryName,
    required this.mainProductImage,
    required this.images,
    required this.isActive,
    required this.variants,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "categoryId": categoryId,
      "categoryName": categoryName,
      "mainProductImage": mainProductImage,
      "images": images,
      "isActive": isActive,
      "variants": variants.map((e) => e.toJson()).toList(),
      "createdAt": createdAt,
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      description: json["description"] ?? "",
      categoryId: json["categoryId"] ?? "",
      categoryName: json["categoryName"] ?? "",
      mainProductImage: json["mainProductImage"] ?? "",
      images: List<String>.from(json["images"] ?? []),
      isActive: json["isActive"] ?? true,
      variants: (json["variants"] as List<dynamic>? ?? [])
          .map((e) => ProductVariant.fromJson(e))
          .toList(),
      createdAt: json['createdAt']?.toDate() ?? DateTime.now(),
    );
  }
}

class ProductVariant {
  final String title;
  final double price;


  ProductVariant({
    required this.title,
    required this.price,

  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "price": price,

    };
  }

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      title: json["title"] ?? "",
      price: (json["price"] ?? 0).toDouble(),

    );
  }
}