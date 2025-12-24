import 'package:core/core.dart';

class ProductListEntity {
  final bool isProductLoading;
  final List<CategoryModel> categories;
  final List<ProductModel> products;
  final Map<String, ProductModel> allProducts;
  final Map<String, int> cart;
  final String? selectcategoryId;

  const ProductListEntity({
    this.isProductLoading = false,
    this.categories = const [],
    this.products = const [],
    this.allProducts = const {},
    this.cart = const {},
    this.selectcategoryId,
  });

  ProductListEntity copyWith({
    bool? isProductLoading,
    List<CategoryModel>? categories,
    List<ProductModel>? products,
    Map<String, ProductModel>? allProducts,
    Map<String, int>? cart,
    String? selectcategoryId,
  }) {
    return ProductListEntity(
      isProductLoading: isProductLoading ?? this.isProductLoading,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      allProducts: allProducts ?? this.allProducts,
      cart: cart ?? this.cart,
      selectcategoryId: selectcategoryId ?? this.selectcategoryId,
    );
  }
}
