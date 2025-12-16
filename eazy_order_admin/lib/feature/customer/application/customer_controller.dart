import 'package:eazy_order_admin/feature/customer/entity/customer_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'customer_controller.g.dart';

@Riverpod(keepAlive: true)
class CustomerController extends _$CustomerController{
  @override
  CustomerEntity build() {
    return CustomerEntity();
  }
}