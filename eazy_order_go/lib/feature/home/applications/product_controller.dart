
import 'dart:io';

import 'package:eazy_order_go/core/services/firebase_storage_service.dart';
import 'package:eazy_order_go/feature/home/applications/category_controller.dart';
import 'package:eazy_order_go/feature/home/entities/product_entity.dart';
import 'package:eazy_order_go/feature/home/repository/category_repository.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'product_controller.g.dart'; // Required for code generation

@Riverpod(keepAlive: true)
class ProductController extends _$ProductController {

  @override
  ProductEntity build() {
    ref.keepAlive();
    return ProductEntity();
  }

  void pickImages() async {
    final images = await ref.read(firebaseStorageServiceProvider).pickMultipleImagesFromGallery();
    List<XFile> prevImages = [...state.images, ...images];
    state = state.copyWith(images: prevImages.sublist(prevImages.length > 5 ? prevImages.length - 5 : 0));
    validate();
  }

  void onNameChanges(String name) {
    state = state.copyWith(productName: name);
    validate();
  }

  void onPriceChanges(String price) {
    state = state.copyWith(price: double.tryParse(price) ?? 0.0);
    validate();
  }

  void onDescChanges(String desc) {
    state = state.copyWith(desc: desc);
  }

  void validate() {
    state = state.copyWith(isValid: state.images.isNotEmpty && state.productName.isNotEmpty && state.price > 0);
  }

  Future saveProduct(String businessId, String categoryId) async {
    if (businessId.isNotEmpty) {
      state = state.copyWith(isLoading: true);
      List<String> imageUrls = [];
      if (state.images.isNotEmpty) {
        imageUrls = await ref.read(firebaseStorageServiceProvider).uploadMultipleProductImages(
            state.images, businessId);
      }
      
      final categoryRepo = ref.read(categoryRepositoryProvider);
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
      await categoryRepo.addProduct(product);
      state = state.copyWith(
        images: [],
        productName: '',
        price: 0.0,
        desc: '',
        isValid: false,
        isLoading: false,
      );
    } else {
      Fluttertoast.showToast(msg: 'Business Id not found');
      debugPrint('Business Id not found');
    }
  }

  Future<void> activeInactiveProduct(
      CategoryModel category,
      String productId,
      bool value
      ) async {
    final categoryRepo = ref.read(categoryRepositoryProvider);
    final updatedProducts = category.products.map((e) {
      if (e.productId == productId) {
        e.isActive = value;
      }
      return e;
    }).toList();
    ref.read(categoryControllerProvider.notifier).updateCategory(productId, value);
    await categoryRepo.updateProducts(category.categoryId, updatedProducts.map((e) => e.toMap()).toList());
  }

  Future deleteProduct(CategoryModel category, String productId) async {
    final categoryRepo = ref.read(categoryRepositoryProvider);
    final updatedProducts = category.products.where((e) => e.productId != productId).toList();
    ref.read(categoryControllerProvider.notifier).deleteProductFromCategory(updatedProducts, productId);
    await categoryRepo.updateProducts(category.categoryId, updatedProducts.map((e) => e.toMap()).toList());
  }

  String _generateRequestId() {
    return const Uuid().v4();
  }
}
