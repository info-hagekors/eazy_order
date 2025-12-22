class OrderEntity {
  final String orderId;
  final String customerinfo;
  final int mobile;
  final String Datetime;
  final int totalamount;

  OrderEntity({
    this.orderId = "",
    this.customerinfo = "",
    this.mobile = 0,
    this.Datetime = "",
    this.totalamount = 0,
  });

  OrderEntity copyWith({
    String? orderId,
    String? customerinfo,
    int? mobile,
    String? Datetime,
    int? totalamount,
  }) {
    return OrderEntity(
      orderId: orderId ?? this.orderId,
      customerinfo: customerinfo ?? this.customerinfo,
      mobile: mobile ?? this.mobile,
      Datetime: Datetime ?? this.Datetime,
      totalamount: totalamount ?? this.totalamount,
    );
  }
}
