
import 'dart:async';

import 'package:eazy_order_go/core/routing/app_router.dart';
import 'package:eazy_order_go/core/services/firebase_functions_service.dart';
import 'package:eazy_order_go/core/services/payment_service.dart';
import 'package:eazy_order_go/feature/home/applications/home_controller.dart';
import 'package:eazy_order_go/feature/home/entities/order_entity.dart';
import 'package:core/core.dart';
import 'package:eazy_order_go/feature/home/repository/order_repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_controller.g.dart'; // Required for code generation

@Riverpod(keepAlive: true)
class OrderController extends _$OrderController {

  StreamSubscription? _subscription;

  @override
  OrderEntity build() {
    ref.keepAlive();
    ref.onDispose(() {
      _subscription?.cancel();
    });
    return OrderEntity();
  }

  Future getOrders(String businessId) async {
    state = state.copyWith(isLoading: true);
    final orderRepo = ref.read(orderRepositoryProvider);
    List<OrderModel> result = await orderRepo.getOrders(businessId);
    state = state.copyWith(
        ordersList: result,
      isLoading: false
    );
  }

  void getTodayOrders(String businessId) {
    _subscription?.cancel();
    state = state.copyWith(isLoading: true, ordersList: []);
    final orderRepo = ref.read(orderRepositoryProvider);
    _subscription = orderRepo.getTodayOrders(businessId, state.selectedOrderStatus).listen((listData) {
      state = state.copyWith(
          ordersList: listData,
          isLoading: false
      );
    });
  }

  void disposeListener() {
    _subscription?.cancel();
  }

  void updateOrderStatus(String orderId, String orderStatus) async {
    final orderRepo = ref.read(orderRepositoryProvider);
    await orderRepo.updateOrderStatus(orderId, orderStatus);
    Fluttertoast.showToast(msg: 'Order status updated successfully!');
    state = state.copyWith(
      ordersList: state.ordersList.map((e) {
        if (e.orderId == orderId) {
          e = e.copyWith(orderStatus: orderStatus);
          return e;
        }
        return e;
      }).toList()
    );
  }

  void showPaymentDetails(String orderId, bool val) {
    state = state.copyWith(
        ordersList: state.ordersList.map((e) {
          if (e.orderId == orderId) {
            e = e.copyWith(showPaymentDetails: val);
            return e;
          }
          return e;
        }).toList()
    );
  }

  void makePaymentForOrder(OrderModel model, BuildContext context) async {
    PaymentService service = PaymentService(
      onSuccess: (response) async {
        model = model.copyWith(
          paymentId: response.paymentId,
          paymentOrderId: response.orderId,
          paymentSignature: response.signature,
          paymentType: 'Online',
          paymentStatus: 'Paid',
        );
        await updateOrderAfterPayment(model);
        //Close the loading dialog
        ref.read(goRouterProvider).pop();
        state = state.copyWith(
            ordersList: state.ordersList.map((e) {
              if (e.orderId == model.orderId) {
                e = model;
                return e;
              }
              return e;
            }).toList()
        );
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

    ref.read(homeControllerProvider.notifier).showLoading(context);

    final response = await ref.read(firebaseFunctionsServiceProvider).createOrder(
      amount: model.orderTotal.round(),
      receipt: model.orderId,
    );

    if (response['success']) {
      final order = response['order'];
      final orderId = order['id'];

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
      //Close the loading dialog
      ref.read(goRouterProvider).pop();
    }
  }

  Future updateOrderAfterPayment(OrderModel model) async {
    final orderRepo = ref.read(orderRepositoryProvider);
    await orderRepo.updateOrderAfterPayment(model);
  }

  void updateNewOrderDetails(OrderModel model) {
    state = state.copyWith(
      ordersList: [model, ...state.ordersList]
    );
  }

  void onSelectOrderStatus(String val) {
    if (val == state.selectedOrderStatus) return;
    state = state.copyWith(selectedOrderStatus: val);
    final businessId = ref.read(homeControllerProvider).businessModel?.businessId ?? '';
    getTodayOrders(businessId);
  }

  void onUpdateOrderPaymentMode(String val, String orderId) {
    state = state.copyWith(
      ordersList: state.ordersList.map((e) {
        if (orderId == e.orderId) {
          e = e.copyWith(selectedPaymentOption: val);
          return e;
        }
        return e;
      }).toList()
    );
  }

  void receivedCashForOrder(OrderModel model) async {
    model = model.copyWith(
      paymentType: 'Cash',
      paymentStatus: 'Paid',
    );
    await updateOrderAfterPayment(model);
    state = state.copyWith(
        ordersList: state.ordersList.map((e) {
          if (e.orderId == model.orderId) {
            e = model;
            return e;
          }
          return e;
        }).toList()
    );
  }
}
