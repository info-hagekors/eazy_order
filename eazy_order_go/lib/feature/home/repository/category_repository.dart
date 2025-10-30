import 'package:eazy_order_go/core/services/firestore_service.dart';
import 'package:core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class CategoryRepository {

  final FirestoreService _firestoreService;

  CategoryRepository(this._firestoreService);

  Future<void> addCategory(CategoryModel model) async {
    final data = {
      'category_id': model.categoryId,
      'business_id': model.businessId,
      'category_name': model.categoryName,
      'ia_active': model.isActive,
      'products': [],
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };
    await _firestoreService.setDocument(FirestoreService.collectionCatalog, model.categoryId, data);
  }

  Future<void> addProduct(ProductModel model) async {
    final data = {
      'category_id': model.categoryId,
      'business_id': model.businessId,
      'product_id': model.productId,
      'product_name': model.productName,
      'price': model.price,
      'description': model.description,
      'ia_active': model.isActive,
      'image_urls': model.imageUrls,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };

    await _firestoreService.updateInnerDocument(FirestoreService.collectionCatalog, model.categoryId, 'products', data);
  }

  Future updateProducts(String categoryId, List<Map<String, dynamic>> products) async {
    await _firestoreService.updateListDocument(FirestoreService.collectionCatalog, categoryId, 'products', products);
  }

  Future updateCategoryName(String categoryId, String categoryName) async {
    await _firestoreService.updateDocument(FirestoreService.collectionCatalog, categoryId, 'category_name', categoryName);
  }

  Future deleteCategory(String categoryId) async {
    await _firestoreService.deleteDocument(FirestoreService.collectionCatalog, categoryId);
  }

  Future<List<CategoryModel>> getAllCategories(String businessId) async {
    final result = await _firestoreService.querySnapshotListData(FirestoreService.collectionCatalog,
        'business_id', businessId);
    final catData = result.map((e) => CategoryModel.fromJson(e)).toList();
    return catData;
  }
}

// Auth Repository provider
final categoryRepositoryProvider = Provider((ref) => CategoryRepository(ref.read(firestoreServiceProvider)));
