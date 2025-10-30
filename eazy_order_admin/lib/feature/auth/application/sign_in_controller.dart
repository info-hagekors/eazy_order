
import 'package:core/core.dart';
import 'package:eazy_order_admin/core/routing/app_router.dart';
import 'package:eazy_order_admin/feature/auth/entity/signin_entity.dart';
import 'package:eazy_order_admin/feature/auth/entity/signup_entity.dart';
import 'package:eazy_order_admin/feature/auth/repository/signin_repository.dart';
import 'package:eazy_order_admin/feature/auth/repository/signup_repository.dart';
import 'package:eazy_order_admin/feature/business/presentations/screens/add_business_screen.dart';
import 'package:eazy_order_admin/feature/main_screen/presentations/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_controller.g.dart'; // Required for code generation

@Riverpod(keepAlive: true)
class SignInController extends _$SignInController {

  @override
  SigninEntity build() {
    ref.keepAlive();
    return SigninEntity();
  }

  void onEmailChange(String val) {
    state = state.copyWith(
      email: val.trim()
    );
    onValidate();
  }

  void onPasswordChange(String val) {
    state = state.copyWith(
      password: val.trim()
    );
    onValidate();
  }

  void onValidate() {
    state = state.copyWith(
      isValid: state.email.isValidEmail && state.password.isNotEmpty
    );
  }

  void onSignInClick() async {
    state = state.copyWith(isLoading: true);
    final signInRepo = ref.read(signInRepositoryProvider);
    final result = await signInRepo.userLogin(state.email, state.password);
    state = result.fold((l) {
      ToastUtils.error(l);
      state = state.copyWith(
          isLoading: false
      );
      return state;
    }, (r) {
      state = state.copyWith(
          isLoading: false
      );
      if (r.businessId.isNotEmpty) {
        //ref.read(goRouterProvider).go(MainScreen.routeName, extra: {'businessId': r.businessId});
        ref.read(goRouterProvider).go('${MainScreen.routeName}?businessId=${r.businessId}');
      } else {
        if (r.role == 'admin') {
          ref.read(goRouterProvider).go(AddBusinessScreen.routeName);
        } else {
          ToastUtils.error('Business not found, Please contact admin.!');
        }
      }
      return state;
    });
  }
}
