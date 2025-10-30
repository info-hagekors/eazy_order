
import 'package:eazy_order_admin/feature/main_screen/entities/main_screen_entity.dart';
import 'package:eazy_order_admin/feature/main_screen/repository/main_screen_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_screen_controller.g.dart'; // Required for code generation

@Riverpod(keepAlive: true)
class MainScreenController extends _$MainScreenController {

  String _businessId = '';

  @override
  MainScreenEntity build() {
    ref.keepAlive();
    return MainScreenEntity();
  }

  void setBusinessId(String businessId) {
    _businessId = businessId;
  }

  String get businessId => _businessId;

  Future getBusinessDetails() async {
    await Future.delayed(Duration(milliseconds: 50));
    state = state.copyWith(
        isLoading: true, isSuccess: false, isFailed: false
    );
    final mainScreenRepo = ref.read(mainScreenRepositoryProvider);
    final result = await mainScreenRepo.getBusinessDetails(businessId);
    state = result.fold(
        (l) {
          state = state.copyWith(
              isLoading: false, isSuccess: false, isFailed: true
          );
          return state;
        },
        (r) {
          state = state.copyWith(
            business: r,
            isLoading: false, isSuccess: true, isFailed: false
          );
          return state;
        }
    );
  }
}
