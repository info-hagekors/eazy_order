
import 'package:core/services/auth_service.dart';
import 'package:eazy_order_pro/core/config/app_images.dart';
import 'package:eazy_order_pro/core/routing/app_router.dart';
import 'package:eazy_order_pro/feature/auth/entities/admin_pin_entity.dart';
import 'package:eazy_order_pro/feature/auth/presentations/widgets/verify_success_dialog.dart';
import 'package:eazy_order_pro/feature/home/presentations/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_pin_controller.g.dart'; // Required for code generation

@riverpod
class AdminPinController extends _$AdminPinController {

  final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

  @override
  AdminPinEntity build() {
    return AdminPinEntity();
  }

  void onPinChanged(String val) {
    state = state.copyWith(pin: val.trim());
    onValidate();
  }

  void onConfirmPinChanged(String val) {
    state = state.copyWith(confirmPin: val.trim());
    onValidate();
  }

  void onValidate() {
    bool isPinValid = (state.pin.length == 4);
    bool isConfirmPinValid = (state.pin == state.confirmPin);
    state = state.copyWith(isValid: isPinValid && isConfirmPinValid);
  }

  Future<void> savePin({required String userId, required String pin,}) async {
    await ref.read(authServiceProvider).savePin(userId: userId, pin: pin);
    showLoginSuccessDialog(navigatorKey.currentContext!);
  }

  void showLoginSuccessDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return VerifySuccessDialog(
            title: 'PIN set successfully',
            subTitle: 'Redirecting you to home page',
            icon: AppImages.icTwoStepVerify,
          );
        }
    ).then((val) {
      if (val ?? false) {
        ref.read(goRouterProvider).go(HomeScreen.routeName);
      }
    });
  }

}
