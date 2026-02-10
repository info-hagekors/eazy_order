
class OrderModel {
  final String orderId;
  final String orderInvoiceNumber;
  final String orderMobileNumber;
  final String orderUserName;
  final String orderStatus;
  final String paymentStatus;
  final List<OrderItems> items;
  final double orderTotal;
  final String paymentType;
  final String businessId;
  final String createdAt;
  final String updatedAt;
  final String paymentId;
  final String paymentOrderId;
  final String paymentSignature;
  final String paymentOption;
  final String orderPreference;
  final bool showPaymentDetails;
  final String tableNumber;
  final String selectedPaymentOption;

  OrderModel({
    required this.orderId,
    required this.orderInvoiceNumber,
    required this.orderMobileNumber,
    required this.orderUserName,
    required this.orderStatus,
    required this.paymentStatus,
    required this.items,
    required this.orderTotal,
    required this.paymentType,
    required this.businessId,
    this.createdAt = '',
    this.updatedAt = '',
    this.paymentId = '',
    this.paymentOrderId = '',
    this.paymentSignature = '',
    this.paymentOption = '',
    this.orderPreference = '',
    this.showPaymentDetails = false,
    this.tableNumber = '',
    this.selectedPaymentOption = 'Cash',
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'] ?? '',
      orderInvoiceNumber: json['order_invoice_number'] ?? '',
      orderMobileNumber: json['order_mobile_number'] ?? '',
      orderUserName: json['order_user_name'] ?? '',
      orderStatus: json['order_status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      items: List<OrderItems>.from(json['items']?.map((x) => OrderItems.fromJson(x)) ?? []),
      orderTotal: json['order_total']?.toDouble() ?? 0.0,
      paymentType: json['payment_type'] ?? '',
      businessId: json['business_id'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      paymentId: json['payment_id'] ?? '',
      paymentOrderId: json['payment_order_id'] ?? '',
      paymentSignature: json['payment_signature'] ?? '',
      paymentOption: json['payment_option'] ?? '',
      orderPreference: json['order_preference'] ?? '',
      tableNumber: json['table_number'] ?? ''
    );
  }

  OrderModel copyWith({ String? orderId, String? orderInvoiceNumber, String? orderMobileNumber,
    String? orderUserName, String? orderStatus, String? paymentStatus, List<OrderItems>? items,
    double? orderTotal, String? paymentType, String? businessId, String? createdAt, String? updatedAt,
    String? paymentId, String? paymentOrderId, String? paymentSignature, String? paymentOption,
    String? orderPreference, bool? showPaymentDetails, String? tableNumber, String? selectedPaymentOption }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      orderInvoiceNumber: orderInvoiceNumber ?? this.orderInvoiceNumber,
      orderMobileNumber: orderMobileNumber ?? this.orderMobileNumber,
      orderUserName: orderUserName ?? this.orderUserName,
      orderStatus: orderStatus ?? this.orderStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      items: items ?? this.items,
      orderTotal: orderTotal ?? this.orderTotal,
      paymentType: paymentType ?? this.paymentType,
      businessId: businessId ?? this.businessId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      paymentId: paymentId ?? this.paymentId,
      paymentOrderId: paymentOrderId ?? this.paymentOrderId,
      paymentSignature: paymentSignature ?? this.paymentSignature,
      paymentOption: paymentOption ?? this.paymentOption,
      orderPreference: orderPreference ?? this.orderPreference,
      showPaymentDetails: showPaymentDetails ?? this.showPaymentDetails,
      tableNumber: tableNumber ?? this.tableNumber,
      selectedPaymentOption: selectedPaymentOption ?? this.selectedPaymentOption,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order_id': orderId,
      'order_invoice_number': orderInvoiceNumber,
      'order_mobile_number': orderMobileNumber,
      'order_user_name': orderUserName,
      'order_status': orderStatus,
      'items': items.map((x) => x.toMap()).toList(),
      'order_total': orderTotal,
      'business_id': businessId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'payment_status': paymentStatus,
      'payment_type': paymentType,
      'payment_id': paymentId,
      'payment_order_id': paymentOrderId,
      'payment_signature': paymentSignature,
      'payment_option': paymentOption,
      'order_preference': orderPreference,
      'table_number': tableNumber,
    };
  }
}

class OrderItems {
  String orderItemId;
  String productName;
  String categoryName;
  String description;
  double price;
  List<String> imageUrls;
  int quantity;

  OrderItems({
    required this.orderItemId,
    required this.productName,
    this.categoryName = '',
    this.description = '',
    required this.price,
    this.imageUrls = const [],
    this.quantity = 0,
  });

  factory OrderItems.fromJson(Map<String, dynamic> json) {
    return OrderItems(
      orderItemId: json['order_item_id'] ?? '',
      productName: json['product_name'] ?? '',
      categoryName: json['category_name'] ?? '',
      description: json['description'] ?? '',
      price: json['price']?.toDouble() ?? 0.0,
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'order_item_id': orderItemId,
      'product_name': productName,
      'category_name': categoryName,
      'description': description,
      'price': price,
      'image_urls': imageUrls,
      'quantity': quantity,
    };
  }
}