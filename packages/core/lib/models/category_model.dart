
import 'package:flutter/material.dart';

class CategoryModel {
  GlobalKey globalKey;
  String categoryId;
  String categoryName;
  String businessId;
  bool isActive;
  List<ProductModel> products;
  bool isOpened;
  String createdAt;
  String updatedAt;

  CategoryModel({
    required this.globalKey,
    required this.categoryId,
    required this.categoryName,
    required this.businessId,
    this.isActive = true,
    this.products = const [],
    this.isOpened = true,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      globalKey: GlobalKey(),
      categoryId: json['category_id'] ?? '',
      categoryName: json['category_name'] ?? '',
      businessId: json['business_id'] ?? '',
      isActive: json['is_active'] ?? false,
      products: List<ProductModel>.from(json['products']?.map((x) => ProductModel.fromJson(x)) ?? []),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
      'business_id': businessId,
      'is_active': isActive,
      'products': products.map((x) => x.toMap()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  String toString() {
    return 'CategoryModel(globalKey: $globalKey, categoryId: $categoryId, categoryName: $categoryName, businessId: $businessId, isActive: $isActive, products: $products, isOpened: $isOpened, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

class ProductModel {
  String productId;
  String productName;
  String categoryId;
  String categoryName;
  String businessId;
  String description;
  double price;
  bool isActive;
  List<String> imageUrls;
  int quantity;
  String createdAt;
  String updatedAt;

  ProductModel({
    required this.productId,
    required this.productName,
    required this.categoryId,
    this.categoryName = '',
    required this.businessId,
    this.description = '',
    required this.price,
    this.isActive = false,
    this.imageUrls = const [],
    this.quantity = 0,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      categoryId: json['category_id'] ?? '',
      businessId: json['business_id'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      isActive: json['is_active'] ?? false,
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      quantity: json['quantity'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'product_name': productName,
      'category_id': categoryId,
      'business_id': businessId,
      'description': description,
      'price': price,
      'is_active': isActive,
      'image_urls': imageUrls,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  set setQuantity(int value) {
    quantity = value;
  }

  set setCategory(String val) {
    categoryName = val;
  }
}