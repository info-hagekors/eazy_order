import 'package:core/core.dart';

class OrderEntity {
  List<OrderModel> orderlist;
  List<OrderItems> items;
  Map<String, int> editableQty;
  bool isEdit;
  String orderId;
  int selectedTab;
  bool isLoading;

  OrderEntity({
    this.orderlist = const [],
    this.items = const [],
    this.editableQty = const {},
    this.isEdit = false,
    this.orderId = '',
    this.selectedTab = 0,
    this.isLoading = false,
  });

  OrderEntity copyWith({
    List<OrderModel>? orderslist,
    List<OrderItems>? items,
    Map<String, int>? editableQty,
    bool? isEdit,
    String? orderId,
    int? selectTab,
    bool? isLoading,
  }) {
    return OrderEntity(
      orderlist: orderslist ?? this.orderlist,
      items: items ?? this.items,
      editableQty: editableQty ?? this.editableQty,
      isEdit: isEdit ?? this.isEdit,
      orderId: orderId ?? this.orderId,
      selectedTab: selectTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
