
import 'package:core/core.dart';

class OrderEntity {
  final List<OrderModel> ordersList;
  final bool isLoading;
  final String selectedOrderStatus;

  OrderEntity({
    this.ordersList = const [],
    this.isLoading = false,
    this.selectedOrderStatus = 'All',
  });

  OrderEntity copyWith({List<OrderModel>? ordersList, bool? isLoading, String? selectedOrderStatus}) {
    return OrderEntity(
      ordersList: ordersList ?? this.ordersList,
      isLoading: isLoading ?? this.isLoading,
      selectedOrderStatus: selectedOrderStatus ?? this.selectedOrderStatus,
    );
  }
}