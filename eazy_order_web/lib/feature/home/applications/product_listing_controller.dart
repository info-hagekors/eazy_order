
import 'package:core/core.dart';
import 'package:eazy_order_web/core/routing/app_router.dart';
import 'package:eazy_order_web/core/services/firebase_functions_service.dart';
import 'package:eazy_order_web/core/services/firebase_notification_service.dart';
import 'package:eazy_order_web/core/services/razorpay_web_service.dart';
import 'package:eazy_order_web/feature/home/entities/product_listing_entity.dart';
import 'package:eazy_order_web/feature/home/presentations/screens/mobile/order_detail_screen.dart';
import 'package:eazy_order_web/feature/home/presentations/widgets/order_status_overlay.dart';
import 'package:core/core.dart';
import 'package:eazy_order_web/feature/home/repositories/product_listing_repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'product_listing_controller.g.dart'; // Required for code generation

@Riverpod(keepAlive: true)
class ProductListingController extends _$ProductListingController {

  @override
  ProductListingEntity build() {
    ref.keepAlive();
    return ProductListingEntity(
      selectedOrderPreference: 'Dine In',
      selectedPaymentOption: 'Online'
    );
  }

  Future getAllCategories(String businessId) async {
    await Future.delayed(Duration(milliseconds: 50));
    final productListingRepo = ref.read(productListingRepositoryProvider);
    List<CategoryModel> result = await productListingRepo.getAllCategories(businessId);
    state = state.copyWith(
        categoryList: result,
      searchedList: result,
      isLoading: false
    );
  }

  void openCloseCategory(String categoryId) {
    state = state.copyWith(
      categoryList: state.categoryList.map((cat) {
        if (cat.categoryId == categoryId) {
          cat.isOpened = !cat.isOpened;
        }
        return cat;
      }).toList(),
    );
  }

  void getBusinessData(String businessId) async {
    await Future.delayed(Duration(milliseconds: 50));
    state = state.copyWith(isLoading: true);
    //Initialize Firebase in case of direct page access
    await FirebaseNotificationService.initialize();
    BusinessModel business = await ref.read(productListingRepositoryProvider).getBusinessData(businessId);
    state = state.copyWith(businessModel: business);
    if (business.businessId.isNotEmpty) {
      getAllCategories(business.businessId);
    } else {
      state = state.copyWith(isLoading: false);
      Fluttertoast.showToast(msg: 'Business Details not found', toastLength: Toast.LENGTH_LONG);
    }
  }

  void addToCart(ProductModel product, String catName) {
    product.setQuantity = 1;
    product.setCategory = catName;
    List<ProductModel> cartItems = state.cartModel?.cartItems.toList() ?? [];
    cartItems.add(product);
    state = state.copyWith(
      cartModel: state.cartModel?.copyWith(
        cartItems: cartItems,
        cartTotal: (state.cartModel?.cartTotal ?? 0) + product.price
      ) ?? CartModel(
        cartItems: cartItems,
        cartTotal: (state.cartModel?.cartTotal ?? 0) + product.price
      )
    );
  }

  void increaseQuantity(ProductModel product) {
    List<ProductModel> cartItems = [...(state.cartModel?.cartItems ?? [])];
    final index = cartItems.indexWhere((item) => item.productId == product.productId);

    if (index != -1) {
      cartItems[index].setQuantity = cartItems[index].quantity + 1;
      final updatedTotal = (state.cartModel?.cartTotal ?? 0) + cartItems[index].price;

      state = state.copyWith(
        cartModel: state.cartModel?.copyWith(
          cartItems: cartItems,
          cartTotal: updatedTotal,
        ),
      );
    }
  }

  void decreaseQuantity(ProductModel product) {
    List<ProductModel> cartItems = [...(state.cartModel?.cartItems ?? [])];
    final index = cartItems.indexWhere((item) => item.productId == product.productId);

    if (index != -1) {
      final existing = cartItems[index];

      if (existing.quantity > 1) {
        existing.setQuantity = existing.quantity - 1;
        final updatedTotal = (state.cartModel?.cartTotal ?? 0) - existing.price;

        state = state.copyWith(
          cartModel: state.cartModel?.copyWith(
            cartItems: cartItems,
            cartTotal: updatedTotal,
          ),
        );
      } else {
        // If quantity becomes 0, remove from cart
        cartItems.removeAt(index);
        final updatedTotal = (state.cartModel?.cartTotal ?? 0) - existing.price;

        state = state.copyWith(
          cartModel: state.cartModel?.copyWith(
            cartItems: cartItems,
            cartTotal: updatedTotal,
          ),
        );
      }
    }
    if (state.cartModel?.cartItems.isEmpty ?? false) {
      goBackOnEmptyCart();
    }
  }

  void goBackOnEmptyCart() {
    Future.delayed(Duration(milliseconds: 100)).then((val) {
      ref.read(goRouterProvider).pop();
    });
  }

  void updateUserDetails(String mobile, String name) {
    state = state.copyWith(
      cartModel: state.cartModel?.copyWith(
        userName: name,
        mobile: mobile
      )
    );
  }

  void checkout(String businessId, BuildContext context) async {
    if (state.tableNumber.isEmpty && state.selectedOrderPreference == 'Dine In') {
      Fluttertoast.showToast(msg: 'Please enter table number');
      return;
    }

    state = state.copyWith(isCartLoading: true);
    OrderModel model = OrderModel(
      orderId: const Uuid().v4(),
      orderInvoiceNumber: '', // Assign in next step
      orderMobileNumber: state.cartModel?.mobile ?? '',
      orderTotal: state.cartModel?.cartTotal ?? 0,
      orderStatus: AppConsts.orderStatus.first.toLowerCase(),
      orderUserName: state.cartModel?.userName ?? '',
      paymentStatus: 'Paid',
      paymentType: state.selectedPaymentOption,
      businessId: businessId,
      paymentOption: state.selectedPaymentOption,
      orderPreference: state.selectedOrderPreference,
      tableNumber: state.tableNumber,
      items: state.cartModel?.cartItems.map((e) => OrderItems(
        orderItemId: e.productId,
        price: e.price,
        quantity: e.quantity,
        productName: e.productName,
        categoryName: e.categoryName,
        imageUrls: e.imageUrls,
        description: e.description
      )).toList() ?? []
    );
    if (state.selectedPaymentOption.toLowerCase() == 'online') {
      await onPayment(model, context);
    } else if (state.selectedPaymentOption.toLowerCase() == 'cash') {
      await placeOrderAndNotifyBusiness(model, context);
    } else {
      model = model.copyWith(
        paymentStatus: AppConsts.paymentStatus.first,
      );
      await placeOrderAndNotifyBusiness(model, context);
    }
  }

  Future onPayment(OrderModel model, BuildContext context) async {
    final response = await ref.read(firebaseFunctionsServiceProvider).createOrder(
      amount: model.orderTotal.round(),
      receipt: model.orderId,
    );

    if (response['success']) {
      final order = response['order'];
      final orderId = order['id'];

      // Now open Razorpay checkout using the Web Razorpay interop service
      RazorpayWebService().openCheckout(
        apiKey: AppConsts.razorpayApiKey,
        orderId: orderId,
        amount: model.orderTotal.round(),
        currency: 'INR',
        customerName: model.orderUserName,
        mobile: model.orderMobileNumber,
        businessName: state.businessModel?.name ?? '',
        businessLogo: state.businessModel?.logo ?? '',
        description: 'eazyOrder Payment',
        onSuccess: (response) async {
          // handle post-payment success
          model = model.copyWith(
            paymentId: response['razorpay_payment_id'] ?? '',
            paymentOrderId: response['razorpay_order_id'] ?? '',
            paymentSignature: response['razorpay_signature'] ?? '',
          );
          await placeOrderAndNotifyBusiness(model, context);
        },
        onFailure: (err) {
          // handle payment failure
          debugPrint('Razorpay Error >>> $err');
          Fluttertoast.showToast(msg: err.isNotEmpty ? err : 'Payment Failed');
          state = state.copyWith(isCartLoading: false);
        },
      );
    } else {
      print('Razorpay Error > ${response.toString()}');
      Fluttertoast.showToast(msg: response['message'] ?? 'Payment error');
      state = state.copyWith(isCartLoading: false);
    }
  }

  void showSuccessDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) => OrderStatusOverlay(isSuccess: true, message: 'Your order has been placed successfully!'),
    ).then((val) {
      state = state.copyWith(isCartLoading: false, cartModel: CartModel());
      ref.read(goRouterProvider).go('${OrderDetailScreen.routeName}/$orderId');
    });
  }

  void onSearch(String val) {
    if (val.isEmpty) {
      state = state.copyWith(searchedList: state.categoryList);
    }

    val = val.toLowerCase();
    final result = <CategoryModel>[];

    for (final category in state.categoryList) {
      final isCategoryMatch = category.categoryName.toLowerCase().contains(val);

      final matchedProducts = category.products.where((product) {
        return product.productName.toLowerCase().contains(val);
      }).toList();

      if (isCategoryMatch && matchedProducts.isEmpty) {
        // If category name matches, but no products match, show all products
        result.add(CategoryModel(
          globalKey: category.globalKey,
          categoryName: category.categoryName,
          products: category.products,
          categoryId: category.categoryId, businessId: category.businessId,
        ));
      } else if (matchedProducts.isNotEmpty) {
        // If only some products match, show only those
        result.add(CategoryModel(
          globalKey: category.globalKey,
          categoryName: category.categoryName,
          products: matchedProducts,
          categoryId: category.categoryId, businessId: category.businessId,
        ));
      }
    }
    state = state.copyWith(searchedList: result);
  }

  void onOrderPreferenceSelection(String val) {
    if (val != 'Dine In') {
      state = state.copyWith(selectedOrderPreference: val, tableNumber: '');
    }
    state = state.copyWith(selectedOrderPreference: val);
  }

  void onTableNumberChanged(String val) {
    state = state.copyWith(tableNumber: val.trim());
  }

  void onPaymentOptionSelection(String val) {
    state = state.copyWith(selectedPaymentOption: val);
  }

  Future placeOrderAndNotifyBusiness(OrderModel model, BuildContext context) async {
    final repo = ref.read(productListingRepositoryProvider);
    final updatedModel = await repo.placeOrder(model);
    await ref.read(firebaseFunctionsServiceProvider).notifyBusinessOnOrder(
        orderId: updatedModel.orderId,
        orderNumber: updatedModel.orderInvoiceNumber,
        customerName: state.cartModel?.userName ?? '',
        token: state.businessModel?.token ?? '',
        amount: (state.cartModel?.cartTotal ?? 0).toString()
    );
    await ref.read(firebaseFunctionsServiceProvider).sendWhatsAppMessage(updatedModel, state.businessModel?.name ?? '');

    showSuccessDialog(context, model.orderId);
  }
}
