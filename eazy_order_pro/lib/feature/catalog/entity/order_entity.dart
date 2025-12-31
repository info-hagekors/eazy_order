import 'package:core/core.dart';

class OrderEntity {
  List<OrderModel> orderlist;
  bool isLoading;


  OrderEntity({this.orderlist = const [],this.isLoading = false});

  OrderEntity copyWith({List<OrderModel>? orderslist, bool? isLoading}) {
    return OrderEntity(orderlist: orderslist ?? this.orderlist,isLoading: isLoading ?? this.isLoading);
  }
}
