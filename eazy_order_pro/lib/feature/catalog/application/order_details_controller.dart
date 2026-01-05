import 'package:eazy_order_pro/feature/catalog/entity/order_detail_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_details_controller.g.dart';

@Riverpod(keepAlive: true)
class OrderDetailController extends _$OrderDetailController{
  @override
  OrderDetailEntity build(){
    return OrderDetailEntity();
  }
}