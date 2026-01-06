import 'package:core/core.dart';

class OrderEntity {
  List<OrderModel> orderlist;
  bool isLoading;
  String username;
  String mobilenumber;
  String orderpreference;

  OrderEntity({
    this.orderlist = const [],
    this.isLoading = false,
    this.username = '',
    this.mobilenumber = '',
    this.orderpreference= 'dine_in',
  });

  OrderEntity copyWith({
    List<OrderModel>? orderslist,
    bool? isLoading,
    String? username,
    String? mobilenumber,
    String? orderpreference
  }) {
    return OrderEntity(
      orderlist: orderslist ?? this.orderlist,
      isLoading: isLoading ?? this.isLoading,
      username: username ?? this.username,
      mobilenumber: mobilenumber ?? this.mobilenumber,
      orderpreference: orderpreference ?? this.orderpreference
    );
  }
}
