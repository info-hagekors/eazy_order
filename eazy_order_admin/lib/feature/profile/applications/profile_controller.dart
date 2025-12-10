import 'package:eazy_order_admin/feature/catalog/entity/product_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_controller.g.dart';

@Riverpod(keepAlive: true)
class ProfileController extends _$ProfileController {
  @override
  ProductEntity build(){
    ref.keepAlive();
    return ProductEntity();
  }
  Future <void> getProfile() async {
    state = state.copyWith(

    );
  }
}