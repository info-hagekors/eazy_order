import 'package:core/models/category_model.dart';

class CategoryEntity {

  final List<CategoryModel> categoriesList;
  final bool isLoading;
  final String searchtext;
  final List<CategoryModel> filteredCategories;


  CategoryEntity({
    this.categoriesList = const [],
    this.isLoading = false,
    this.searchtext = '',
    this.filteredCategories = const []
  });

  CategoryEntity copyWith({
    List<CategoryModel>? categoriesList,
    bool? isLoading,
    String? searchtext,
    List<CategoryModel>? filteredCategories
  })
  {
    return CategoryEntity(
      categoriesList: categoriesList ?? this.categoriesList,
      isLoading: isLoading ?? this.isLoading,
      searchtext: searchtext ?? this.searchtext,
      filteredCategories: filteredCategories ?? this.filteredCategories
    );
  }
}
