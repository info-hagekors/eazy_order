
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:eazy_order_pro/feature/home/entities/home_entity.dart';

part 'home_controller.g.dart';

@Riverpod(keepAlive: true)
class HomeController extends _$HomeController {

  @override
  HomeEntity build() {
    ref.keepAlive();
    return HomeEntity();
  }

  void onPageChange(int val) {
    state = state.copyWith(selectedPage: val);
  }

}
