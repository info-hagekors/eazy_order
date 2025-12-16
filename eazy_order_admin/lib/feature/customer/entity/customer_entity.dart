class CustomerEntity {
  final String customerId;
  final String customerName;
  final String orderId;

  CustomerEntity({
    this.customerId = "",
    this.customerName = "",
    this.orderId = "",
  });

  CustomerEntity copyWith({
    String? customerId,
    String? customerName,
    String? orderId,
  }) {
    return CustomerEntity(
      customerName: customerName ?? this.customerName,
      customerId: customerId ?? this.customerId,
      orderId: orderId ?? this.orderId,
    );
  }
}
