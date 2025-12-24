import 'package:core/core.dart';
import 'package:eazy_order_pro/feature/catalog/entity/product_list_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_listing_controller.g.dart';

@Riverpod(keepAlive: true)
class ProductListingController extends _$ProductListingController {
  @override
  ProductListEntity build() {
    return ProductListEntity();
  }
  void reset() {
    state = ProductListEntity();
  }

  void addItem(String productId) {
    final newCart = Map<String, int>.from(state.cart);
    newCart[productId] = (newCart[productId] ?? 0) + 1;
    state = state.copyWith(cart: newCart);
  }

  void removeItem(String productId) {
    final newCart = Map<String, int>.from(state.cart);

    if (!newCart.containsKey(productId)) return;

    if (newCart[productId] == 1) {
      newCart.remove(productId);
    } else {
      newCart[productId] = newCart[productId]! - 1;
    }

    state = state.copyWith(cart: newCart);
  }

  void clearItem(String title) {
    final newCart = Map<String, int>.from(state.cart);
    newCart.remove(title);
    state = state.copyWith(cart: newCart);
  }

  Future<void> getactivecategory(String businessId) async {
    final category = ref.read(categoryRepositoryProvider);
    final result = await category.getActiveCategories(businessId);
    state = state.copyWith(
        categories: result,
        selectcategoryId: null
    );
  }

  Future<void>getactiveproduct(String categoryId) async{
    state = state.copyWith(
      isProductLoading: true,
      products: [],
      selectcategoryId: categoryId
    );
    final product = ref.read(productRepositoryProvider);
    final result = await product.getProductsByCategoryId(categoryId);
    final updatedAllProducts = Map<String, ProductModel>.from(state.allProducts);

    for (final product in result) {
      if (product.productId != null) {
        updatedAllProducts[product.productId!] = product;
      }
    }
    state = state.copyWith(
        products: result,
        allProducts: updatedAllProducts,
      isProductLoading: false
    );
  }
}
