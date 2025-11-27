import 'package:core/core.dart';
import 'package:eazy_order_admin/core/services/firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductRepository{

  final FirestoreService _firestoreService;

  ProductRepository(this._firestoreService);

  Future<void> addProduct(ProductModel model) async{
    final data = {
      'category_id': model.categoryId,
      'business_id': model.businessId,
      'product_id': model.productId,
      'product_name': model.productName,
      'price': model.price,
      'description': model.description,
      'ia_active': model.isActive,
      'image_urls':model.imageUrls,
      'createdAt': DateTime.now,
      'updatedAt': DateTime.now(),
    };
    await _firestoreService.updateInnerDocument(FirestoreService.collectionCatalog,model.categoryId,'product',data);
  }
  Future updateProduct(String categoryId, List<Map<String, dynamic>> products) async {
    await _firestoreService.updateListDocument(FirestoreService.collectionCatalog,categoryId,'products', products);
  }
}

final productRepositoryProvider = Provider((ref)=> ProductRepository(ref.read(firestoreServiceProvider)));