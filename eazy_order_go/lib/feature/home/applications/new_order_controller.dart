
import 'package:eazy_order_go/core/routing/app_router.dart';
import 'package:eazy_order_go/core/services/firebase_functions_service.dart';
import 'package:eazy_order_go/core/services/payment_service.dart';
import 'package:eazy_order_go/feature/home/applications/home_controller.dart';
import 'package:eazy_order_go/feature/home/entities/new_order_entity.dart';
import 'package:eazy_order_go/feature/home/presentations/screens/home_screen.dart';
import 'package:eazy_order_go/feature/home/presentations/widgets/order_status_overlay.dart';
import 'package:core/core.dart';
import 'package:eazy_order_go/feature/home/repository/new_order_repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'new_order_controller.g.dart'; // Required for code generation

@Riverpod(keepAlive: true)
class NewOrderController extends _$NewOrderController {

  @override
  NewOrderEntity build() {
    ref.keepAlive();
    return NewOrderEntity(
        selectedOrderPreference: 'Dine In',
        selectedPaymentOption: 'Pay Later at Counter'
    );
  }

  Future getAllCategories() async {
    await Future.delayed(Duration(milliseconds: 50));
    final productListingRepo = ref.read(newOrderRepositoryProvider);
    final businessId = ref.read(homeControllerProvider).businessModel?.businessId ?? '';
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

  void updateUserDetails(String mobile, String name) {
    state = state.copyWith(
        cartModel: state.cartModel?.copyWith(
            userName: name,
            mobile: mobile
        )
    );
  }

  void onOrderPreferenceSelection(String val) {
    state = state.copyWith(selectedOrderPreference: val);
  }

  void onPaymentOptionSelection(String val) {
    state = state.copyWith(selectedPaymentOption: val);
  }

  void checkout(String businessId, BuildContext context) async {
    state = state.copyWith(isCartLoading: true);
    OrderModel model = OrderModel(
        orderId: const Uuid().v4(),
        orderInvoiceNumber: '', // Assign in next step
        orderMobileNumber: state.cartModel?.mobile ?? '',
        orderTotal: state.cartModel?.cartTotal ?? 0,
        orderStatus: AppConsts.orderStatus.first,
        orderUserName: state.cartModel?.userName ?? '',
        paymentStatus: 'Paid',
        paymentType: state.selectedPaymentOption,
        businessId: businessId,
        paymentOption: state.selectedPaymentOption,
        orderPreference: state.selectedOrderPreference,
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
      await placeOrderAndNotifyCustomer(model, context);
    } else {
      model = model.copyWith(
        paymentStatus: AppConsts.paymentStatus.first,
      );
      await placeOrderAndNotifyCustomer(model, context);
    }
  }

  Future placeOrderAndNotifyCustomer(OrderModel model, BuildContext context) async {
    final repo = ref.read(newOrderRepositoryProvider);
    final orderId = await repo.placeOrder(model);
    /*await ref.read(firebaseFunctionsServiceProvider).sendWhatsAppMessage(
        model.orderMobileNumber, 'Test Message from eazy order'
    );*/
    showSuccessDialog(context, model);
  }

  void showSuccessDialog(BuildContext context, OrderModel model) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) => OrderStatusOverlay(isSuccess: true, message: 'Your order has been placed successfully!'),
    ).then((val) {
      state = state.copyWith(isCartLoading: false, cartModel: CartModel());
      ref.read(homeControllerProvider.notifier).getBusinessData(null);
      ref.read(goRouterProvider).go(HomeScreen.routeName);
    });
  }

  Future onPayment(OrderModel model, BuildContext context) async {
    final response = await ref.read(firebaseFunctionsServiceProvider).createOrder(
      amount: model.orderTotal.round(),
      receipt: model.orderId,
    );

    if (response['success']) {
      final order = response['order'];
      final orderId = order['id'];

      PaymentService service = PaymentService(
        onSuccess: (response) async {
          model = model.copyWith(
            paymentId: response.paymentId,
            paymentOrderId: response.orderId,
            paymentSignature: response.signature,
            paymentType: 'Online',
            paymentStatus: 'Paid',
          );
          await placeOrderAndNotifyCustomer(model, context);
          //ToDo: Send whatsapp notification to customer
        },
        onError: (code, message) {
          //Close the loading dialog
          ref.read(goRouterProvider).pop();
          debugPrint("Payment Error: $code - $message");
          Fluttertoast.showToast(msg: 'Payment Error: $code - $message');
          // Show error message
        },
      );

      final state = ref.read(homeControllerProvider);
      service.openCheckout(
          orderId: orderId,
          amount: model.orderTotal.round(),
          customerName: model.orderUserName,
          mobile: model.orderMobileNumber,
          businessName: state.businessModel?.name ?? '',
          businessLogo: state.businessModel?.logo ?? '',
          orderNumber: model.orderInvoiceNumber
      );
    } else {
      debugPrint('Razorpay Error > ${response.toString()}');
      Fluttertoast.showToast(msg: response['message'] ?? 'Payment error');
      state = state.copyWith(isCartLoading: false);
    }
  }
}
