
import 'dart:typed_data';
import 'package:core/core.dart';
import 'package:core/models/category_model.dart'; // contains ProductModel
import 'package:core/repositories/product_repository.dart';
import 'package:eazy_order_admin/feature/catalog/application/category_controller.dart';
import 'package:eazy_order_admin/feature/catalog/entity/product_entity.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  Future<void> getAllProducts(String businessId) async {
    try {
      final productRepo = ref.read(productRepositoryProvider);
      final products = await productRepo.getAllProducts(businessId);
      final categories = ref.read(categoryControllerProvider).categoriesList;
      List<ProductModel> updatedResult = products;
      for (int i = 0; i <categories.length; i++) {
        final category = categories[i];
        updatedResult = updatedResult.map((e) {
          if (e.categoryId == category.categoryId) {
            e.categoryName = category.categoryName;
          }
          return e;
        }).toList();
      }

      state = state.copyWith(products: updatedResult);
    } catch (e) {
      ToastUtils.error('Failed to load products');
    }
  }

  Future saveProduct(
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
      uploadedUrls = await storage.uploadMultipleProductImagesWeb(images, businessId,);
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
    Fluttertoast.showToast(msg: "Product added successfully...");
  }

  Future updateProduct(ProductModel model) async {
    if (model.productName.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please enter product name");
      return;
    }
    if (model.businessId.trim().isEmpty) {
      Fluttertoast.showToast(msg: "businessId not found");
      return;
    }
    final productRepo = ref.read(productRepositoryProvider);
    await productRepo.updateProduct(model);

    state = state.copyWith(
      products: state.products.map((e) {
        if (e.productId == model.productId) {
          return model;
        }
        return e;
      }).toList()
    );
    Fluttertoast.showToast(msg: "Product updated successfully...");
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final productRepo = ref.read(productRepositoryProvider);
      await productRepo.deleteProduct(productId);
      state = state.copyWith(products: state.products.where((p) => p.productId != productId).toList());
      Fluttertoast.showToast(msg: "Product deleted");
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to delete product");
    }
  }

  Future onActiveInActive(String productId, bool val) async {
    List<ProductModel> list = state.products.toList();
    list = list.map((e) {
      if(e.productId == productId) {
        e.isActive = val;
      }
      return e;
    }).toList();
    state = state.copyWith(products: list);
    await ref.read(productRepositoryProvider).setActiveInActive(productId, val);
  }
}