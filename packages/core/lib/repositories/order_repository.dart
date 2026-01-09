
import 'package:core/models/order_model.dart';
import 'package:core/services/firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderRepository {

  final FirestoreService _firestoreService;

  OrderRepository(this._firestoreService);

  Future<List<OrderModel>> getOrders(String businessId, {int limit = 10}) async {
    final result = await _firestoreService.querySnapshotListDataV2(
      FirestoreService.collectionOrder,
      { 'business_id' : businessId },
      limit: limit
    );
    final orderData = result.map((e) => OrderModel.fromJson(e)).toList();
    return orderData;
  }

  Future<OrderModel?> getOrderDetailsById(String orderId) async {
    final result = await _firestoreService.getDocument(FirestoreService.collectionOrder, orderId);
    if (result.data() == null) {
      return null;
    }
    final orderData = OrderModel.fromJson(result.data() as Map<String, dynamic>);
    return orderData;
  }

  /*Stream<List<OrderModel>> getTodayOrders(String businessId, String orderStatus) {
    final result = _firestoreService.todayOrderSnapshot(
        businessId, orderStatus
    );
    return result.map((e) => e.map((e) => OrderModel.fromJson(e)).toList());
  }*/

  Future updateOrderStatus(String orderId, String orderStatus) async {
    await _firestoreService.updateMultiFieldDocument(
        FirestoreService.collectionOrder,
        orderId,
        [
          {'field': 'order_status', 'value': orderStatus},
          {'field': 'updated_at', 'value': DateTime.now().toIso8601String()},
        ]
    );
  }

  Future<void> updateOrderAfterPayment(OrderModel model) async {
    await _firestoreService.updateMultiFieldDocument(
        FirestoreService.collectionOrder,
        model.orderId,
        [
          {'field': 'payment_id', 'value': model.paymentId},
          {'field': 'payment_order_id', 'value': model.paymentOrderId},
          {'field': 'payment_signature', 'value': model.paymentSignature},
          {'field': 'payment_status', 'value': model.paymentStatus},
          {'field': 'payment_type', 'value': model.paymentType},
          {'field': 'updated_at', 'value': DateTime.now().toIso8601String()},
        ]
    );
  }

  Future<void> updateOrderAfterCashPayment(OrderModel model) async {
    await _firestoreService.updateMultiFieldDocument(
        FirestoreService.collectionOrder,
        model.orderId,
        [
          {'field': 'payment_status', 'value': model.paymentStatus},
          {'field': 'payment_type', 'value': model.paymentType},
          {'field': 'updated_at', 'value': DateTime.now().toIso8601String()},
        ]
    );
  }

  Future<String> placeOrder(OrderModel model) async {
    model = model.copyWith(
      updatedAt: DateTime.now().toIso8601String(),
      createdAt: DateTime.now().toIso8601String(),
    );
    final invoiceId = await _firestoreService.placeOrder(FirestoreService.collectionOrder, model.orderId, model.toMap());
    return invoiceId;
  }

  Future updateOrder(OrderModel model) async {
    final items = model.items.map((e) => e.toMap()).toList();
    await _firestoreService.updateOrderTransaction(model.orderId, items);
  }
}

final orderRepositoryProvider = Provider((ref)=> OrderRepository(ref.read(firestoreServiceProvider)));