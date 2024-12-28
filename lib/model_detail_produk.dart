// To parse this JSON data, do
//
//     final modelDetailProduk = modelDetailProdukFromJson(jsonString);

import 'dart:convert';

ModelDetailProduk modelDetailProdukFromJson(String str) => ModelDetailProduk.fromJson(json.decode(str));

String modelDetailProdukToJson(ModelDetailProduk data) => json.encode(data.toJson());

class ModelDetailProduk {
  Data data;
  String message;

  ModelDetailProduk({
    required this.data,
    required this.message,
  });

  factory ModelDetailProduk.fromJson(Map<String, dynamic> json) => ModelDetailProduk(
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "message": message,
  };
}

class Data {
  Product product;
  int productId;
  List<ReviewElement> reviews;

  Data({
    required this.product,
    required this.productId,
    required this.reviews,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    product: Product.fromJson(json["product"]),
    productId: json["product_id"],
    reviews: List<ReviewElement>.from(json["reviews"].map((x) => ReviewElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "product": product.toJson(),
    "product_id": productId,
    "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
  };
}

class Product {
  DateTime createdAt;
  String description;
  int id;
  String name;
  int price;
  DateTime updatedAt;

  Product({
    required this.createdAt,
    required this.description,
    required this.id,
    required this.name,
    required this.price,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    createdAt: DateTime.parse(json["createdAt"]),
    description: json["description"],
    id: json["id"],
    name: json["name"],
    price: json["price"],
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt.toIso8601String(),
    "description": description,
    "id": id,
    "name": name,
    "price": price,
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class ReviewElement {
  String id;
  int productId;
  ReviewReview review;

  ReviewElement({
    required this.id,
    required this.productId,
    required this.review,
  });

  factory ReviewElement.fromJson(Map<String, dynamic> json) => ReviewElement(
    id: json["_id"],
    productId: json["product_id"],
    review: ReviewReview.fromJson(json["review"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "product_id": productId,
    "review": review.toJson(),
  };
}

class ReviewReview {
  String comment;
  int ratings;

  ReviewReview({
    required this.comment,
    required this.ratings,
  });

  factory ReviewReview.fromJson(Map<String, dynamic> json) => ReviewReview(
    comment: json["comment"],
    ratings: json["ratings"],
  );

  Map<String, dynamic> toJson() => {
    "comment": comment,
    "ratings": ratings,
  };
}