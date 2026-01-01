import 'package:core/core.dart';

class ProductEntity {
  final List<ProductModel> products;
  final bool isLoading;

  ProductEntity({
    this.products = const [],
    this.isLoading = false
  });

  ProductEntity copyWith({
    List<ProductModel>? products,
    bool? isLoading,
  }) {
    return ProductEntity(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading
    );
  }
}