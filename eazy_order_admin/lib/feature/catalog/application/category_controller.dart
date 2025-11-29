
import 'package:core/models/category_model.dart';
import 'package:core/repositories/category_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../entity/category_entity.dart';

part 'category_controller.g.dart';


@Riverpod(keepAlive: true)
class CategoryController extends _$CategoryController {

  @override
  CategoryEntity build() {
    ref.keepAlive();
    return CategoryEntity();
  }

  Future<void> getAllCategoiescontroller(String businessId) async {
    final categoryRepo = ref.read(categoryRepositoryProvider);
    List<CategoryModel> result = await categoryRepo.getAllCategories(businessId);
    if(result.isNotEmpty){
      CategoryModel firstCat = result.first;
      firstCat.isOpened = true;
      result[0]= firstCat;
    }
    state = state.copyWith(
      categoriesList: result
    );
  }

  Future savaCategorycontroller(String name, String businessId) async {
    if(name.isEmpty){
      Fluttertoast.showToast(msg: "please enter category name");
      return;
    }
    if(businessId.isNotEmpty){
      Fluttertoast.showToast(msg: "save succesfully");
      final categoryRepo = ref.read(categoryRepositoryProvider);
      CategoryModel category = CategoryModel(
          globalKey: GlobalKey(), 
          categoryId: _generateRequestId(), 
          categoryName: name, 
          businessId: businessId
      );
      await categoryRepo.addCategory(category);
    }else{
      Fluttertoast.showToast(msg: 'Business Id not found');
    }
  }

  Future updateCategoryfromcontroller(String name, String categoryId) async {
    if(name.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter category name');
      return;
    }
   final categoryRepo = ref.read(categoryRepositoryProvider);
    await categoryRepo.updateCategoryName(categoryId, name);
  }

  Future deleteCategoryfromcontroller(String categoryId) async {
    Fluttertoast.showToast(msg: 'category is deleted');
    final categoryRepo = ref.read(categoryRepositoryProvider);
    await categoryRepo.deleteCategory(categoryId);
  }

  String _generateRequestId() {
    return const Uuid().v4();
  }
}


