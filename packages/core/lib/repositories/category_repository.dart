
import 'package:core/models/category_model.dart';
import 'package:core/services/firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryRepository {

  final FirestoreService _firestoreService;

  CategoryRepository(this._firestoreService);

  Future addCategory(CategoryModel model) async {
    model.createdAt = DateTime.now().toIso8601String();
    model.updatedAt = DateTime.now().toIso8601String();
    final data = model.toMap();
    await _firestoreService.setDocument(FirestoreService.collectionCategory, model.categoryId, data);
  }

  Future<void> updateCategoryName(String categoryId, String categoryName) async {
    await _firestoreService.updateDocument(FirestoreService.collectionCategory, categoryId, 'category_name', categoryName,);
  }

  Future<void> deleteCategory(String categoryId) async {
    await _firestoreService.deleteDocument(FirestoreService.collectionCategory, categoryId);
  }

  Future<void> setActiveInActive(String categoryId, bool isActive) async {
    await _firestoreService.updateDocument(FirestoreService.collectionCategory, categoryId, 'is_active', isActive);
  }

  Future<List<CategoryModel>> getAllCategories(String businessId) async {
    final result = await _firestoreService.querySnapshotListData(
      FirestoreService.collectionCategory,
      'business_id',
      businessId,
      isOrderBy: true
    );
    final catData = result.map((e)=> CategoryModel.fromJson(e)).toList();
    return catData;
  }

  Future<List<CategoryModel>> getActiveCategories(String businessId) async {
    final result = await _firestoreService.querySnapshotListDataV2(
        FirestoreService.collectionCategory,
        {'business_id' : businessId, 'is_active' : true},
        isOrderBy: true
    );
    final catData = result.map((e)=> CategoryModel.fromJson(e)).toList();
    return catData;
  }
}

final categoryRepositoryProvider = Provider((ref)=> CategoryRepository(ref.read(firestoreServiceProvider)));