
import 'package:core/core.dart';
import 'package:eazy_order_admin/feature/catalog/entity/category_entity.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'category_controller.g.dart';


@Riverpod(keepAlive: true)
class CategoryController extends _$CategoryController {

  @override
  CategoryEntity build() {
    ref.keepAlive();
    return CategoryEntity();
  }

  Future<void> getAllCategories(String businessId) async {
    final categoryRepo = ref.read(categoryRepositoryProvider);
    state = state.copyWith(isLoading: true);
    final result = await categoryRepo.getAllCategories(businessId);
    state = state.copyWith(
      isLoading: false,
      categoriesList: result
    );
  }

  Future savaCategory(String name, String businessId) async {
    if(name.isEmpty){
      ToastUtils.error('Please enter category name...');
      return;
    }
    if(businessId.isNotEmpty){
      final categoryRepo = ref.read(categoryRepositoryProvider);
      CategoryModel category = CategoryModel(
        globalKey: GlobalKey(),
        categoryId: _generateRequestId(),
        categoryName: name,
        businessId: businessId,
        isActive: true
      );
      await categoryRepo.addCategory(category);
    }else{
      ToastUtils.error('Something went wrong...');
    }
  }

  Future updateCategory(String name, String categoryId) async {
    if(name.isEmpty) {
      ToastUtils.error('Please enter category name...');
      return;
    }
    final categoryRepo = ref.read(categoryRepositoryProvider);
    await categoryRepo.updateCategoryName(categoryId, name);
  }

  Future deleteCategory(String categoryId) async {
    final categoryRepo = ref.read(categoryRepositoryProvider);
    await categoryRepo.deleteCategory(categoryId);
    ToastUtils.success('Category deleted successfully...');
  }

  String _generateRequestId() {
    return const Uuid().v4();
  }

  Future onActiveInActive(String categoryId, bool val) async {
    List<CategoryModel> list = state.categoriesList.toList();
    list = list.map((e) {
      if(e.categoryId == categoryId) {
        e.isActive = val;
      }
      return e;
    }).toList();
    state = state.copyWith(categoriesList: list);
    await ref.read(categoryRepositoryProvider).setActiveInActive(categoryId, val);
  }
}


