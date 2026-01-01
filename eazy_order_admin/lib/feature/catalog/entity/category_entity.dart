import 'package:core/models/category_model.dart';

class CategoryEntity {

  final List<CategoryModel> categoriesList;
  final bool isLoading;

  CategoryEntity({
    this.categoriesList = const [],
    this.isLoading = false
  });

  CategoryEntity copyWith({
    List<CategoryModel>? categoriesList,
    bool? isLoading
  })
  {
    return CategoryEntity(
      categoriesList: categoriesList ?? this.categoriesList,
      isLoading: isLoading ?? this.isLoading
    );
  }
}
