class OrderDetailEntity {
  String orderdetail;

  OrderDetailEntity({this.orderdetail = ''});

  OrderDetailEntity copyWith({String? orderdetail}) {
    return OrderDetailEntity(orderdetail: orderdetail ?? this.orderdetail);
  }
}
