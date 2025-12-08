import 'package:core/core.dart';

class ProductEntity {
  final List<ProductModel> products;

  ProductEntity({
    this.products = const [],
  });

  ProductEntity copyWith({
    List<ProductModel>? products,
  }) {
    return ProductEntity(
      products: products ?? this.products,
    );
  }
}