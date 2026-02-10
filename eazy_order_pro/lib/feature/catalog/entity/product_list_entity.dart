import 'package:core/core.dart';

class ProductListEntity {
  final bool isLoading;
  final String productId;
  final int selectindex;
  final bool isProductLoading;
  final List<CategoryModel> categories;
  final List<ProductModel> products;
  final Map<String, ProductModel> allProducts;
  final Map<String, int> cart;
  final String? selectcategoryId;
  bool isEdit;
  String username;
  String mobilenumber;
  String orderpreference;
  String orderId;

  ProductListEntity({
    this.isLoading = false,
    this.productId = '',
    this.selectindex = 0,
    this.isProductLoading = false,
    this.categories = const [],
    this.products = const [],
    this.allProducts = const {},
    this.cart = const {},
    this.selectcategoryId,
    this.isEdit = false,
    this.username = '',
    this.mobilenumber = '',
    this.orderpreference = 'dine_in',
    this.orderId=''

  });

  ProductListEntity copyWith({
    bool? isLoading,
    String? productId,
    int? selectindex,
    bool? isProductLoading,
    List<CategoryModel>? categories,
    List<ProductModel>? products,
    Map<String, ProductModel>? allProducts,
    Map<String, int>? cart,
    String? selectcategoryId,
    bool? isEdit,
    String? username,
    String? mobilenumber,
    String? orderpreference,
    String? orderId
  }) {
    return ProductListEntity(
      isLoading: isLoading ?? this.isLoading,
      productId: productId ?? this.productId,
      selectindex: selectindex ?? this.selectindex,
      isProductLoading: isProductLoading ?? this.isProductLoading,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      allProducts: allProducts ?? this.allProducts,
      cart: cart ?? this.cart,
      selectcategoryId: selectcategoryId ?? this.selectcategoryId,
      isEdit: isEdit ?? this.isEdit,
      username: username ?? this.username,
      mobilenumber: mobilenumber ?? this.mobilenumber,
      orderpreference: orderpreference ?? this.orderpreference,
      orderId: orderId ?? this.orderId,
    );
  }
}
