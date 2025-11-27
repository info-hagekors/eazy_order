import 'package:core/models/category_model.dart';

class CategoryEntity {

  final List<CategoryModel> categoriesList;

  CategoryEntity({
    this.categoriesList = const [],
  });

  CategoryEntity copyWith({
    List<CategoryModel>? categoriesList
  })
  {
    return CategoryEntity(
      categoriesList: categoriesList ?? this.categoriesList
    );
  }
}
