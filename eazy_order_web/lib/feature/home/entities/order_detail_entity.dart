
import 'package:core/core.dart';

/*
//Order Status
1. Placed
2. Cancelled
3. Failed
4. Completed
 */

class OrderDetailEntity {
  final OrderModel? orderModel;
  final bool isLoading;

  OrderDetailEntity({
    this.orderModel,
    this.isLoading = false,
  });

  OrderDetailEntity copyWith({OrderModel? orderModel, bool? isLoading}) {
    return OrderDetailEntity(
      orderModel: orderModel ?? this.orderModel,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}