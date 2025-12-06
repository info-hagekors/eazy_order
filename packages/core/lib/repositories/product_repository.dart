
import 'package:core/core.dart';
import 'package:core/services/firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductRepository{

  final FirestoreService _firestoreService;

  ProductRepository(this._firestoreService);

  Future<void> addProduct(ProductModel model) async{
    model.createdAt = DateTime.now().toIso8601String();
    model.updatedAt = DateTime.now().toIso8601String();
    final data = model.toMap();
    await _firestoreService.setDocument(FirestoreService.collectionProduct, model.productId, data);
  }

  Future updateProduct(ProductModel model) async {
    model.updatedAt = DateTime.now().toIso8601String();
    final data = model.toMap();
    await _firestoreService.setDocument(FirestoreService.collectionProduct, model.productId, data);
  }

  Future<void> deleteProduct(String productId) async {
    await _firestoreService.deleteDocument(FirestoreService.collectionProduct, productId);
  }

  Future<void> setActiveInActive(String productId, bool isActive) async {
    await _firestoreService.updateDocument(FirestoreService.collectionProduct, productId, 'ia_active', isActive);
  }

  Future<List<ProductModel>> getAllProducts(String businessId) async {
    final result = await _firestoreService.querySnapshotListData(
      FirestoreService.collectionProduct,
      'business_id',
      businessId,
    );
    final data = result.map((e)=> ProductModel.fromJson(e)).toList();
    return data;
  }

  Future updateProducts(String categoryId, List<Map<String, dynamic>> products) async {
    await _firestoreService.updateListDocument(FirestoreService.collectionCatalog, categoryId, 'products', products);
  }
}

final productRepositoryProvider = Provider((ref)=> ProductRepository(ref.read(firestoreServiceProvider)));