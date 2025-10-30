
import 'package:eazy_order_go/core/services/firestore_service.dart';
import 'package:core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class NewOrderRepository {

  final FirestoreService _firestoreService;

  NewOrderRepository(this._firestoreService);

  Future<List<CategoryModel>> getAllCategories(String businessId) async {
    final result = await _firestoreService.querySnapshotListData(FirestoreService.collectionCatalog,
        'business_id', businessId);
    final catData = result.map((e) => CategoryModel.fromJson(e)).toList();
    return catData;
  }

  Future<BusinessModel> getBusinessData(String businessId) async {
    final result = await _firestoreService.querySnapshotSingleData(
        FirestoreService.collectionBusiness, 'business_id', businessId
    );
    BusinessModel model = BusinessModel.fromJson(result);
    return model;
  }

  Future<String> placeOrder(OrderModel model) async {
    model = model.copyWith(
      updatedAt: DateTime.now().toIso8601String(),
      createdAt: DateTime.now().toIso8601String(),
    );
    await _firestoreService.setOrderTransaction(FirestoreService.collectionOrder, model.orderId, model.toMap());
    return model.orderId;
  }
}

// Product Listing Repository provider
final newOrderRepositoryProvider = Provider((ref) => NewOrderRepository(ref.read(firestoreServiceProvider)));
