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

  void addItem(String title) {
    final newCart = Map<String, int>.from(state.cart);
    newCart[title] = (newCart[title] ?? 0) + 1;
    state = state.copyWith(cart: newCart);
  }

  void removeItem(String title) {
    final newCart = Map<String, int>.from(state.cart);

    if (!newCart.containsKey(title)) return;

    if (newCart[title] == 1) {
      newCart.remove(title);
    } else {
      newCart[title] = newCart[title]! - 1;
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
    List<CategoryModel> result = await category.getActiveCategories(businessId);
    state = state.copyWith(categories: result);
  }

  Future<void>getactiveproduct(String categoryId) async{
    state = state.copyWith(isProductLoading: true);
    final product = ref.read(productRepositoryProvider);
    List<ProductModel> result = await product.getProductsByCategoryId(categoryId);
    state = state.copyWith(
        products: result,
      isProductLoading: false
    );
  }
}
