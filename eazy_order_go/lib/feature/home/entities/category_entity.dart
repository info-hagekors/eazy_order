
import 'package:core/core.dart';

class CategoryEntity {
  final List<CategoryModel> categoryList;

  CategoryEntity({
    this.categoryList = const [],
  });

  CategoryEntity copyWith({List<CategoryModel>? categoryList}) {
    return CategoryEntity(
      categoryList: categoryList ?? this.categoryList,
    );
  }
}