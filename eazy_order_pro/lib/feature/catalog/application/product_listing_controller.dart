import 'package:core/core.dart';
import 'package:eazy_order_pro/feature/catalog/entity/order_entity.dart';
import 'package:eazy_order_pro/feature/catalog/entity/product_list_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

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
    final newCart = Map<String, int>.from(state.cart);        //create a new cart with the current cart.....
    newCart[productId] = (newCart[productId] ?? 0) + 1;       //increase the quantity of the product by 1.....
    state = state.copyWith(cart: newCart);                    //update the state with the new cart.....
  }

  void removeItem(String productId) {
    final newCart = Map<String, int>.from(state.cart);      //create a new cart with the current cart.....

    if (!newCart.containsKey(productId)) return;          //if the product is not in the cart, return.....

    if (newCart[productId] == 1) {         //if the quantity is 1, than remove the item(productId) from the cart......
      newCart.remove(productId);
    } else {
      newCart[productId] = newCart[productId]! - 1;   //if the quantity is more than 1, decrease the quantity by 1.....
    }

    state = state.copyWith(cart: newCart);  //update the state with the new cart.....
  }

  void clearCart() {
    state = state.copyWith(
      cart: {},
      username: '',
      mobilenumber: '',
      productId: '',
      orderpreference: 'dine_in',
      selectcategoryId: '',
      orderId: '',
      selectindex: null,
    );
  }

  Future<void> getactivecategory(String businessId) async {
    state = state.copyWith(isLoading: true);
    final category = ref.read(categoryRepositoryProvider);
    final result = await category.getActiveCategories(businessId);
    state = state.copyWith(
      isLoading: false,
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

  Future<void> orderPlace(
      String businessId,
      List<OrderItems> items,
      double totalAmount,
      ) async {
    final orderRepo = ref.read(orderRepositoryProvider);

    OrderModel order = OrderModel(
      orderId: state.isEdit ? state.orderId! : _generatedRequestid(),
      businessId: businessId,
      orderInvoiceNumber: _generatedInvoiceNumber(),
      orderUserName: state.username,
      orderMobileNumber: state.mobilenumber,
      orderStatus: 'placed',
      orderPreference: state.orderpreference,
      paymentStatus: 'pending',
      items: items,
      orderTotal: totalAmount,
      paymentType: 'cash',
    );
    await orderRepo.placeOrder(order);
  }

  void loadCartFromOrderItems(List<OrderItems> items){
    final cart = <String, int>{};
    for (final item in items) {
      cart[item.orderItemId] = item.quantity;
    }
    state = state.copyWith(cart: cart);
  }

  void selectindex(int index){
    state = state.copyWith(
      selectindex: index
    );
  }
  void updateContact({required String name, required String number}) {
    state = state.copyWith(username: name, mobilenumber: number);
  }

  String _generatedRequestid() {
    return const Uuid().v4();
  }
  String _generatedInvoiceNumber() {
    return '';
  }
  void orderpreference(String preference) {
    state = state.copyWith(orderpreference: preference);
  }
}
