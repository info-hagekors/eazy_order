

import 'package:flutter/material.dart';

class CategoryModel {
  GlobalKey globalKey;
  String categoryId;
  String categoryName;
  String businessId;
  bool isActive;
  List<ProductModel> products;
  bool isOpened;

  CategoryModel({
    required this.globalKey,
    required this.categoryId,
    required this.categoryName,
    required this.businessId,
    this.isActive = true,
    this.products = const [],
    this.isOpened = true,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      globalKey: GlobalKey(),
      categoryId: json['category_id'] ?? '',
      categoryName: json['category_name'] ?? '',
      businessId: json['business_id'] ?? '',
      isActive: json['ia_active'] ?? false,
      products: List<ProductModel>.from(json['products']?.map((x) => ProductModel.fromJson(x)) ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
      'business_id': businessId,
      'ia_active': isActive,
      'products': products.map((x) => x.toMap()).toList(),
    };
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
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      categoryId: json['category_id'] ?? '',
      businessId: json['business_id'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      isActive: json['ia_active'] ?? false,
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'product_name': productName,
      'category_id': categoryId,
      'category_name': categoryName,
      'business_id': businessId,
      'description': description,
      'price': price,
      'ia_active': isActive,
      'image_urls': imageUrls,
      'quantity': quantity,
    };
  }

  set setQuantity(int value) {
    quantity = value;
  }

  set setCategory(String val) {
    categoryName = val;
  }
}