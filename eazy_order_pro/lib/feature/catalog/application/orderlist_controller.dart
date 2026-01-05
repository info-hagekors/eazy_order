import 'package:core/models/order_model.dart';
import 'package:core/repositories/order_repository.dart';
import 'package:eazy_order_pro/feature/catalog/entity/order_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'orderlist_controller.g.dart';

@Riverpod(keepAlive: true)
class OrderListController extends _$OrderListController {
  @override
  OrderEntity build() {
    return OrderEntity();
  }

  Future<void> orderPlace(
    String businessId,
    String userName,
    String mobileNumber,
    List<OrderItems> items,
    double totalAmount,
    String orderpreferences,

  ) async {
    final orderRepo = ref.read(orderRepositoryProvider);

    OrderModel order = OrderModel(
      orderId: _generatedRequestid(),
      businessId: businessId,
      orderInvoiceNumber: _generatedInvoiceNumber(),
      orderUserName: userName,
      orderMobileNumber: mobileNumber,
      orderStatus: 'pending',
      orderPreference: orderpreferences,
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
    state = state.copyWith(orderslist: result, isLoading: false);
  }

  void updateContact({
    required String username,
    required String mobilenumber
  }) {
    state = state.copyWith(
        username: username,
        mobilenumber: mobilenumber
    );
  }
  void clear(){
    state = state.copyWith(
      username: '',
      mobilenumber: ''
    );
  }

  void orderpreference(String preference){
    state = state.copyWith(orderpreference: preference);
  }

  String _generatedRequestid() {
    return const Uuid().v4();
  }

  String _generatedInvoiceNumber() {
    return '';
  }
}
