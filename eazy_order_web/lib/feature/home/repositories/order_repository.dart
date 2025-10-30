
import 'package:eazy_order_web/core/services/firestore_service.dart';
import 'package:core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class OrderRepository {

  final FirestoreService _firestoreService;

  OrderRepository(this._firestoreService);

  Future<OrderModel> getOrderDetailsById(String orderId) async {
    try {
      final result = await _firestoreService.querySnapshotSingleData(FirestoreService.collectionOrder,
          'order_id', orderId);
      final order = OrderModel.fromJson(result);
      return order;
    } catch (e) {
      print(e.toString());
      return OrderModel.fromJson({});
    }
  }
}

// Order Repository provider
final orderRepositoryProvider = Provider((ref) => OrderRepository(ref.read(firestoreServiceProvider)));
