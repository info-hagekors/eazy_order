
import 'package:eazy_order_web/core/services/firebase_notification_service.dart';
import 'package:eazy_order_web/feature/home/entities/order_detail_entity.dart';
import 'package:eazy_order_web/feature/home/repositories/order_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_detail_controller.g.dart'; // Required for code generation

@Riverpod(keepAlive: true)
class OrderDetailController extends _$OrderDetailController {

  @override
  OrderDetailEntity build() {
    ref.keepAlive();
    return OrderDetailEntity();
  }

  Future getOrderDetails(String orderId) async  {
    await Future.delayed(Duration(milliseconds: 50));
    state = state.copyWith(isLoading: true);
    //Initialize Firebase in case of direct page access
    await FirebaseNotificationService.initialize();
    final orderRepo = ref.read(orderRepositoryProvider);
    final order = await orderRepo.getOrderDetailsById(orderId);
    state = state.copyWith(orderModel: order, isLoading: false);
  }


}
