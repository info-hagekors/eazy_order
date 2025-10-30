
import 'package:core/core.dart';
import 'package:eazy_order_go/feature/home/entities/category_entity.dart';
import 'package:eazy_order_go/feature/home/repository/category_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'category_controller.g.dart'; // Required for code generation

@Riverpod(keepAlive: true)
class CategoryController extends _$CategoryController {

  @override
  CategoryEntity build() {
    ref.keepAlive();
    return CategoryEntity();
  }

  Future getAllCategories(String businessId) async {
    final categoryRepo = ref.read(categoryRepositoryProvider);
    List<CategoryModel> result = await categoryRepo.getAllCategories(businessId);
    if (result.isNotEmpty) {
      CategoryModel firstCat = result.first;
      firstCat.isOpened = true;
      result[0] = firstCat;
    }
    state = state.copyWith(
      categoryList: result
    );
  }

  Future saveCategory(String name, String businessId) async {
    if (name.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter category name');
      debugPrint('Please enter category name');
      return;
    }
    if (businessId.isNotEmpty) {
      final categoryRepo = ref.read(categoryRepositoryProvider);
      CategoryModel category = CategoryModel(
          globalKey: GlobalKey(),
          businessId: businessId,
          categoryId: _generateRequestId(),
          categoryName: name,
        isActive: true
      );
      await categoryRepo.addCategory(category);
    } else {
      Fluttertoast.showToast(msg: 'Business Id not found');
      debugPrint('Business Id not found');
    }
  }

  Future updateCategoryName(String name, String categoryId) async {
    if (name.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter category name');
      debugPrint('Please enter category name');
      return;
    }
    final categoryRepo = ref.read(categoryRepositoryProvider);
    await categoryRepo.updateCategoryName(categoryId, name);
  }

  Future deleteCategory(String categoryId) async {
    final categoryRepo = ref.read(categoryRepositoryProvider);
    await categoryRepo.deleteCategory(categoryId);
  }

  void updateCategory(String productId, bool val) {
    state = state.copyWith(
      categoryList: state.categoryList.map((cat) {
        final products = cat.products.map((pro) {
          if (pro.productId == productId) {
            pro.isActive = val;
          }
          return pro;
        }).toList();
        cat.products = products;
        return cat;
      }).toList()
    );
  }

  void deleteProductFromCategory(List<ProductModel> updatedProducts, String productId) {
    state = state.copyWith(
      categoryList: state.categoryList.map((cat) {
        final products = cat.products.where((pro) => pro.productId != productId).toList();
        cat.products = products;
        return cat;
      }).toList()
    );
  }

  void openCloseCategory(String categoryId) {
    state = state.copyWith(
      categoryList: state.categoryList.map((cat) {
        if (cat.categoryId == categoryId) {
          cat.isOpened = true;
        } else {
          cat.isOpened = false;
        }
        return cat;
      }).toList(),
    );
  }

  String _generateRequestId() {
    return const Uuid().v4();
  }
}
