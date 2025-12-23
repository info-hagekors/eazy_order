import 'package:core/core.dart';

class ProductListEntity {
  final bool isProductLoading;
  final List<CategoryModel> categories;
  final List<ProductModel> products;
  final Map<String, int> cart;

  const ProductListEntity({
    this.isProductLoading = false,
    this.categories=const [],
    this.products= const [],
    this.cart = const {},
  });

  ProductListEntity copyWith({
    bool? isProductLoading,
    List<CategoryModel>? categories,
    List<ProductModel>? products,
    Map<String, int>? cart,
  }) {
    return ProductListEntity(
      isProductLoading: isProductLoading ?? this.isProductLoading,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      cart: cart ?? this.cart,
    );
  }
}
