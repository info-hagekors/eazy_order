import 'package:eazy_order_admin/feature/order/entity/order_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_controller.g.dart';

@Riverpod(keepAlive: true)
class OrderController extends _$OrderController {
  @override
  OrderEntity build(){
    ref.keepAlive();
    return OrderEntity();
  }

  void saveorder({required String? orderId, required String? customerinfo, required int? mobile, required String? Datetime, required int? totalamount}){
    state = state.copyWith(orderId: orderId, customerinfo: customerinfo, mobile: mobile, Datetime: Datetime, totalamount: totalamount);
  }

  OrderEntity getorder(){
    return OrderEntity();
  }

  void updateorder(OrderEntity order){
    state = order;
  }
}