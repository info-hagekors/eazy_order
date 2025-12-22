
import 'package:core/core.dart';
import 'package:core/repositories/category_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:eazy_order_pro/feature/home/entities/home_entity.dart';

part 'home_controller.g.dart';

@Riverpod(keepAlive: true)
class HomeController extends _$HomeController {

  @override
  HomeEntity build() {
    ref.keepAlive();
    return HomeEntity(currentUser: UserModel());
  }

  void onPageChange(int val) {
    state = state.copyWith(selectedPage: val);
  }

  void setUserData(UserModel user) {
    state = state.copyWith(currentUser: user);
  }

  void getdata() {
    final categoryRepo = ref.read(categoryRepositoryProvider);
    categoryRepo.getActiveCategories(state.currentUser.businessId);

    ref.read(homeControllerProvider).currentUser.businessId;
  }

}
