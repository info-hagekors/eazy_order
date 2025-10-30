
class ReportModel {
  final String date;
  final int top3CategoriesRevenue;
  final int top3CategoriesOrders;
  final int top3ItemsRevenue;
  final int top3ItemsOrders;
  final PaymentMethod topPaymentMethod;
  final Map<String, Summary> categorySummary;
  final Map<String, Summary> itemSummary;
  final String createdAt;
  final Map<String, int> paymentMethodSummary;
  final int totalOrders;
  final String updatedAt;
  final List<Item> bottom3Items;
  final double avgFulfillmentTime;
  final List<Item> top3Items;
  final int totalSales;
  final List<Item> top3Categories;
  final double totalFulfillmentTime;

  ReportModel({
    required this.date,
    required this.top3CategoriesRevenue,
    required this.top3CategoriesOrders,
    required this.top3ItemsRevenue,
    required this.top3ItemsOrders,
    required this.topPaymentMethod,
    required this.categorySummary,
    required this.itemSummary,
    required this.createdAt,
    required this.paymentMethodSummary,
    required this.totalOrders,
    required this.updatedAt,
    required this.bottom3Items,
    required this.avgFulfillmentTime,
    required this.top3Items,
    required this.totalSales,
    required this.top3Categories,
    required this.totalFulfillmentTime,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      date: json['date'] ?? '',
      top3CategoriesRevenue: json['top_3_categories_revenue'] ?? 0,
      top3CategoriesOrders: json['top_3_categories_orders'] ?? 0,
      top3ItemsRevenue: json['top_3_items_revenue'] ?? 0,
      top3ItemsOrders: json['top_3_items_orders'] ?? 0,
      topPaymentMethod: PaymentMethod.fromJson(json['top_payment_method'] ?? {}),
      categorySummary: Map<String, Summary>.fromEntries(
        ((json['_category_summary'] ?? {}) as Map).entries.map(
              (e) => MapEntry(e.key as String, Summary.fromJson(Map<String, dynamic>.from(e.value))),
        ),
      ),
      itemSummary: Map<String, Summary>.fromEntries(
        ((json['_item_summary'] ?? {}) as Map).entries.map(
              (e) => MapEntry(e.key as String, Summary.fromJson(Map<String, dynamic>.from(e.value))),
        ),
      ),
      createdAt: json['created_at'] ?? '',
      paymentMethodSummary: Map<String, int>.from(json['_payment_method_summary'] ?? {}),
      totalOrders: json['total_orders'] ?? 0,
      updatedAt: json['updated_at'] ?? '',
      bottom3Items: List<Item>.from((json['bottom_3_items'] ?? []).map((e) => Item.fromJson(e))),
      avgFulfillmentTime: ((json['avg_fulfillment_time'] ?? 0) as num).toDouble(),
      top3Items: List<Item>.from((json['top_3_items'] ?? []).map((e) => Item.fromJson(e))),
      totalSales: json['total_sales'] ?? 0,
      top3Categories: List<Item>.from((json['top_3_categories'] ?? []).map((e) => Item.fromJson(e))),
      totalFulfillmentTime: ((json['_total_fulfillment_time'] ?? 0) as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'top_3_categories_revenue': top3CategoriesRevenue,
    'top_3_categories_orders': top3CategoriesOrders,
    'top_3_items_revenue': top3ItemsRevenue,
    'top_3_items_orders': top3ItemsOrders,
    'top_payment_method': topPaymentMethod.toJson(),
    '_category_summary': categorySummary.map((k, v) => MapEntry(k, v.toJson())),
    '_item_summary': itemSummary.map((k, v) => MapEntry(k, v.toJson())),
    'created_at': createdAt,
    '_payment_method_summary': paymentMethodSummary,
    'total_orders': totalOrders,
    'updated_at': updatedAt,
    'bottom_3_items': bottom3Items.map((e) => e.toJson()).toList(),
    'avg_fulfillment_time': avgFulfillmentTime,
    'top_3_items': top3Items.map((e) => e.toJson()).toList(),
    'total_sales': totalSales,
    'top_3_categories': top3Categories.map((e) => e.toJson()).toList(),
    '_total_fulfillment_time': totalFulfillmentTime,
  };
}

class PaymentMethod {
  final int revenue;
  final String method;

  PaymentMethod({required this.revenue, required this.method});

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    revenue: json['revenue'] ?? 0,
    method: json['method'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'revenue': revenue,
    'method': method,
  };
}

class Summary {
  final int revenue;
  final int orders;

  Summary({required this.revenue, required this.orders});

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    revenue: json['revenue'] ?? 0,
    orders: json['orders'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'revenue': revenue,
    'orders': orders,
  };
}

class Item {
  final int revenue;
  final String name;
  final int orders;

  Item({required this.revenue, required this.name, required this.orders});

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    revenue: json['revenue'] ?? 0,
    name: json['name'] ?? '',
    orders: json['orders'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'revenue': revenue,
    'name': name,
    'orders': orders,
  };
}
