
import 'package:core/models/category_model.dart';
import 'package:core/services/firebase_storage_service.dart';
import 'package:eazy_order_admin/feature/catalog/entity/product_entity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../repository/product_repository.dart';
import 'category_controller.dart';
part "product_controller.g.dart";

@riverpod
class ProductController extends _$ProductController{
  @override
  ProductEntity build(){
    ref.keepAlive();
    return ProductEntity();
  }

/*  void pickImages() async {
    final images = await ref.read(firebaseStorageServiceProvider).pickImageFromGallery();
    List<XFile> prevImages = [...state.images, ...images];
    state = state.copyWith(images: prevImages.sublist(prevImages.length > 5 ? prevImages.length -5 : 0));
    validate();
  }*/

  void onNameChanges(String name){
    state = state.copyWith(productName: name);
    validate();
  }

  void onPriceChanges(String price){
    state = state.copyWith(price: double.tryParse(price) ?? 0.0);
    validate();
  }

  void onDescChanges(String desc) {
    state = state.copyWith(desc: desc);
  }

  void validate() {
    state =state.copyWith(isvalid: state.images.isNotEmpty && state.productName.isNotEmpty && state.price > 0);
  }

  Future saveProduct(String businessId, String categoryId) async {
    if (businessId.isNotEmpty) {
      state = state.copyWith(isLoading: true);
      List<String> imageUrls = [];
      if (state.images.isNotEmpty) {
        imageUrls = await ref.read(firebaseStorageServiceProvider).uploadMultipleProductImages(
            state.images, businessId);
      }

      final productRepo = ref.read(productRepositoryProvider);
      ProductModel product = ProductModel(
          businessId: businessId,
          categoryId: categoryId,
          productId: _generateRequestId(),
          productName: state.productName,
          price: state.price,
          description: state.desc,
          isActive: true,
          imageUrls: imageUrls
      );
      await productRepo.addProduct(product);
      state = state.copyWith(
        images: [],
        productName: '',
        price: 0.0,
        desc: '',
        isLoading: false,
      );
    } else {
      Fluttertoast.showToast(msg: 'Business Id not found');
    }
  }




/*
  Future deleteProduct(ProductModel product, String productId) async {
    final productRepo = ref.read(productRepositoryProvider);
    final updatedProducts = product.productId.where((e) => e.productId != productId).toList();
    ref.read(categoryControllerProvider.notifier).deleteCategoryfromcontroller(updatedProducts);
    await productRepo.updateProduct(product.categoryId, updatedProducts.map((e) => e.toMap()).toList());
  }
*/


  String _generateRequestId() {
    return const Uuid().v4();
  }





}