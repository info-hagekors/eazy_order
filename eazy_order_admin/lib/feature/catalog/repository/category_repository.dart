
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/models/category_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/firestore_service.dart';

class CategoryRepository {

  final FirestoreService _firestoreService;

  CategoryRepository(this._firestoreService);

  Future addCategoryrepo(CategoryModel model) async {
   final data = {

     'category_id': model.categoryId,
     'business_id': model.businessId,
     'category_name': model.categoryName,
     'ia_active': model.isActive,
     'products': [],
     'createdAt': DateTime.now(),
     'updatedAt': DateTime.now(),
   };
await _firestoreService.setDocument(FirestoreService.collectionCatalog,model.categoryId,data);
  }

  Future<void> updateCategorynamefromrepo(String categoryId, String categoryname) async {
    await _firestoreService.updateDocument(
      FirestoreService.collectionCatalog,
      categoryId,
      'category_name',
      categoryname,
    );
  }

  Future<void> deleteCategoryfromrepo(String categoryId) async {
    await _firestoreService.deleteDocument(FirestoreService.collectionCatalog, categoryId);
  }

  Future<List<CategoryModel>> getAllCategoriesrepo(String businessId) async {
    final result = await _firestoreService.querySnapshotListData(FirestoreService.collectionCatalog,
      'business_id', businessId,);
      final catData = result.map((e)=> CategoryModel.fromJson(e)).toList();
    return catData;
  }
}


final CategoryRepositoryProvider = Provider((ref)=> CategoryRepository(ref.read(firestoreServiceProvider)));