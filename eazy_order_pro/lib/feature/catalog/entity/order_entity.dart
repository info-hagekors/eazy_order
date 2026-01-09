import 'package:core/core.dart';

class OrderEntity {
  List<OrderModel> orderlist;
  List<OrderItems> items;
  bool isEdit;
  String orderId;
  bool isLoading;
  String username;
  String mobilenumber;
  String orderpreference;

  OrderEntity({
    this.orderlist = const [],
    this.items = const [],
    this.isEdit = false,
    this.orderId = '',
    this.isLoading = false,
    this.username = '',
    this.mobilenumber = '',
    this.orderpreference= 'dine_in',
  });

  OrderEntity copyWith({
    List<OrderModel>? orderslist,
    List<OrderItems>? items,
    bool? isEdit,
    String? orderId,
    bool? isLoading,
    String? username,
    String? mobilenumber,
    String? orderpreference
  }) {
    return OrderEntity(
      orderlist: orderslist ?? this.orderlist,
      items: items ?? this.items,
      isEdit: isEdit ?? this.isEdit,
      orderId: orderId ?? this.orderId,
      isLoading: isLoading ?? this.isLoading,
      username: username ?? this.username,
      mobilenumber: mobilenumber ?? this.mobilenumber,
      orderpreference: orderpreference ?? this.orderpreference
    );
  }
}
