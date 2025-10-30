
import 'package:core/models/category_model.dart';

class CartModel {
  final List<ProductModel> cartItems;
  final double cartTotal;
  final String mobile;
  final String userName;

  CartModel({
    this.cartItems = const [],
    this.cartTotal = 0.0,
    this.mobile = '',
    this.userName = '',
  });

  CartModel copyWith({List<ProductModel>? cartItems, double? cartTotal, String? mobile, String? userName}) {
    return CartModel(
      cartItems: cartItems ?? this.cartItems,
      cartTotal: cartTotal ?? this.cartTotal,
      mobile: mobile ?? this.mobile,
      userName: userName ?? this.userName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cartItems': cartItems.map((x) => x.toMap()).toList(),
      'cartTotal': cartTotal,
      'mobile': mobile,
      'userName': userName,
    };
  }
}