
import 'package:core/core.dart';

class NewOrderEntity {
  final List<CategoryModel> categoryList;
  final List<CategoryModel> searchedList;
  final BusinessModel? businessModel;
  final CartModel? cartModel;
  final bool isLoading;
  final bool isCartLoading;
  final String selectedOrderPreference;
  final String selectedPaymentOption;

  NewOrderEntity({
    this.categoryList = const [],
    this.searchedList = const [],
    this.businessModel,
    this.cartModel,
    this.isLoading = false,
    this.isCartLoading = false,
    this.selectedOrderPreference = '',
    this.selectedPaymentOption = '',
  });

  NewOrderEntity copyWith({List<CategoryModel>? categoryList, BusinessModel? businessModel,
    CartModel? cartModel, bool? isLoading, bool? isCartLoading, List<CategoryModel>? searchedList,
    String? selectedOrderPreference, String? selectedPaymentOption}) {
    return NewOrderEntity(
      categoryList: categoryList ?? this.categoryList,
      businessModel: businessModel ?? this.businessModel,
      cartModel: cartModel ?? this.cartModel,
      isLoading: isLoading ?? this.isLoading,
      isCartLoading: isCartLoading ?? this.isCartLoading,
      searchedList: searchedList ?? this.searchedList,
      selectedOrderPreference: selectedOrderPreference ?? this.selectedOrderPreference,
      selectedPaymentOption: selectedPaymentOption ?? this.selectedPaymentOption,
    );
  }
}