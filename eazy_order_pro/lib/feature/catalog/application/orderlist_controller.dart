import 'package:core/models/order_model.dart';
import 'package:core/repositories/order_repository.dart';
import 'package:eazy_order_pro/feature/catalog/entity/order_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'orderlist_controller.g.dart';

@Riverpod(keepAlive: true)
class OrderListController extends _$OrderListController {
  @override
  OrderEntity build() {
    return OrderEntity();
  }

  Future<void> orderPlace(
      String businessId,
      String orderId,
      String orderInvoiceNumber,
      String userName,
      String mobileNumber,
      List<OrderItems> items,
      double totalAmount,
      ) async {

    final orderRepo = ref.read(orderRepositoryProvider);

      final order = OrderModel(
        orderId: orderId,
        businessId: businessId,
        orderInvoiceNumber: orderInvoiceNumber,
        orderUserName: userName,
        orderMobileNumber: mobileNumber,
        orderStatus: 'pending',
        paymentStatus: 'pending',
        items: items,
        orderTotal: totalAmount,
        paymentType: 'cash',
      );
      await orderRepo.placeOrder(order);
  }


  Future<void> getorder(String businessId) async {
    state = state.copyWith(isLoading: true);
      final orderrepo = ref.read(orderRepositoryProvider);
      final result = await orderrepo.getOrders(businessId);
      state = state.copyWith(
          orderslist: result,
          isLoading: false
      );
  }
}
