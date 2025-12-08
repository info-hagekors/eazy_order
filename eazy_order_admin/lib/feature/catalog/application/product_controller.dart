// application/product_controller.dart
import 'dart:typed_data';
import 'package:core/core.dart';
import 'package:core/models/category_model.dart'; // contains ProductModel
import 'package:core/repositories/product_repository.dart';
import 'package:eazy_order_admin/feature/catalog/entity/product_entity.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part "product_controller.g.dart";

@riverpod
class ProductController extends _$ProductController {
  final _uuid = const Uuid();

  @override
  ProductEntity build() {
    // keep provider alive across UI changes
    ref.keepAlive();
    return ProductEntity();
  }


  Future<void> getAllProductfromController(String businessId) async {
    try {
      final productRepo = ref.read(productRepositoryProvider);
      final products = await productRepo.getAllProducts(businessId);

      state = state.copyWith(products: products);
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to load products");
    }
  }

  /// Save product. Optional images can be passed; controller uploads them and sets imageUrls.
  Future saveProductfromcontroller(
    String productName,
    String businessId,
    String categoryId,
    String categoryName,
    String price,
    String description,
    List<Uint8List> images,
  ) async {
    if (productName.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter product name");
      return;
    }
    if (businessId.trim().isEmpty) {
      Fluttertoast.showToast(msg: "businessId not found");
      return;
    }
    final productRepo = ref.read(productRepositoryProvider);
    final storage = ref.read(firebaseStorageServiceProvider);
    final productId = _uuid.v4();

    List<String> uploadedUrls = [];
    if (images.isNotEmpty) {
      final imageFiles = images.map((bytes)=> XFile.fromData(
        bytes,
      name: '${productId}_${_uuid.v4()}.jpg')).toList();
      uploadedUrls = await storage.uploadMultipleProductImages(imageFiles, businessId,);
    }
    final product = ProductModel(
      productId: productId,
      productName: productName,
      businessId: businessId,
      categoryName: categoryName,
      categoryId: categoryId,
      description: description,
      price: double.tryParse(price) ?? 0.0,
      isActive: true,
      imageUrls: uploadedUrls,
      quantity: 0,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
    await productRepo.addProduct(product);

    state = state.copyWith(products: [product, ...state.products],);
    Fluttertoast.showToast(msg: "product Added");

  }

  Future<void> deleteProductfromcontroller(String productId) async {
    try {
      final productRepo = ref.read(productRepositoryProvider);
      await productRepo.deleteProduct(productId);
      state = state.copyWith(products: state.products.where((p) => p.productId != productId).toList());
      Fluttertoast.showToast(msg: "Product deleted");
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to delete product");
    }
  }
}