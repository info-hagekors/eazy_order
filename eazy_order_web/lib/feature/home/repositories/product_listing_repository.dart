
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eazy_order_web/core/services/firestore_service.dart';
import 'package:core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class ProductListingRepository {

  final FirestoreService _firestoreService;

  ProductListingRepository(this._firestoreService);

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

  Future<OrderModel> placeOrder(OrderModel model) async {
    model = model.copyWith(
      updatedAt: DateTime.now().toIso8601String(),
      createdAt: DateTime.now().toIso8601String(),
    );
    final String invoiceNo = await _firestoreService.setOrderTransaction(FirestoreService.collectionOrder, model.orderId, model.toMap());
    model = model.copyWith(
      orderInvoiceNumber: invoiceNo,
    );
    return model;
  }


}

// Product Listing Repository provider
final productListingRepositoryProvider = Provider((ref) => ProductListingRepository(ref.read(firestoreServiceProvider)));
