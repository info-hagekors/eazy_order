
import 'package:core/services/auth_service.dart';
import 'package:core/utils/toast_utils.dart';
import 'package:core/widgets/loading_dialog.dart';
import 'package:eazy_order_pro/core/config/app_images.dart';
import 'package:eazy_order_pro/core/routing/app_router.dart';
import 'package:eazy_order_pro/feature/auth/entities/login_entity.dart';
import 'package:eazy_order_pro/feature/auth/presentations/screens/login_screen.dart';
import 'package:eazy_order_pro/feature/auth/presentations/widgets/verify_success_dialog.dart';
import 'package:eazy_order_pro/feature/home/applications/home_controller.dart';
import 'package:eazy_order_pro/feature/home/presentations/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_controller.g.dart'; // Required for code generation

@riverpod
class LoginController extends _$LoginController {

  final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

  @override
  LoginEntity build() {
    return LoginEntity();
  }

  void onEmailChanged(String val) {
    state = state.copyWith(email: val.trim());
    onValidate();
  }

  void onPasswordChanged(String val) {
    state = state.copyWith(password: val);
    onValidate();
  }

  bool isValidEmail(String email) {
    return emailRegex.hasMatch(email);
  }

  void onValidate() {
    if (state.isLoginWithEmail) {
      bool isEmailValid = (state.email.isNotEmpty && isValidEmail(state.email));
      bool isPassValid = state.password.length > 3;
      state = state.copyWith(isValid: isEmailValid && isPassValid);
    } else {
      bool isMobileValid = (state.mobile.isNotEmpty && state.mobile.length == 10);
      state = state.copyWith(isValid: isMobileValid);
    }
  }

  void showPassword() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void onMobileChanged(String val) {
    state = state.copyWith(mobile: val.trim(), countryCode: '+91');
    onValidate();
  }

  Future userLogin(BuildContext context) async {
    if (state.isLoginWithEmail) {
      await _loginWithEmail(context);
    } else {

    }
  }

  Future _loginWithEmail(BuildContext context) async {
    final authService = ref.read(authServiceProvider);
    showLoadingDialog(context);
    final result = await authService.loginWithEmail(state.email, state.password);

    hideLoadingDialog(context);
    state = result.fold((l) {
      ToastUtils.error(l);
      return state;
    }, (r) {
      ref.read(homeControllerProvider.notifier).setUserData(r);
      showLoginSuccessDialog(context);
      return state;
    });
  }

  void showLoginSuccessDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return VerifySuccessDialog(
            title: 'Login successfully',
            subTitle: 'User verified. Redirecting you to the homepage',
            icon: AppImages.icTwoStepVerify,
          );
        }
    ).then((val) {
      if (val ?? false) {
        ref.read(goRouterProvider).go(HomeScreen.routeName);
      }
    });
  }

  void onUpdateLocalAuthToken(String token) {
    //ref.read(authServiceProvider).updateToken(token);
  }

  void logout() async {
    //await ref.read(authRepositoryProvider).logout();
    //await ref.read(secureStorageServiceProvider).deleteAll();
    ref.read(goRouterProvider).go(LoginScreen.routeName);
  }

  void onLoginMethodChange(bool isLoginWithEmail) {
    state = state.copyWith(isLoginWithEmail: isLoginWithEmail);
  }

  void showOtpDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          //return VerifyDialog(countryCode: '+91', mobile: state.mobile,);
          return SizedBox();
        }
    ).then((val) {
      if (val ?? false) {
        //ref.read(goRouterProvider).go(HomeScreen.routeName);
      }
    });
  }

  String onEnterOtp(String key, bool isBack) {
    if (isBack) {
      if (state.enteredOtp.isNotEmpty) {
        final val = state.enteredOtp;
        state = state.copyWith(enteredOtp: val.substring(0, val.length - 1));
      }
    } else if (state.enteredOtp.length < 6) {
      String enteredOTP = state.enteredOtp;
      state = state.copyWith(enteredOtp: enteredOTP + key);
    }
    return state.enteredOtp;
  }

  void navigateToForgotPassword() {
    //ref.read(goRouterProvider).push(ChangePassword.routeName);
  }

  void validateTokenAndNavigate() async {
    /*final token = await ref.read(secureStorageServiceProvider).getAuthToken();
    if (token.isNotEmpty) {
      ref.read(authRepositoryProvider).updateToken(token);
      ref.read(goRouterProvider).go(HomeScreen.routeName);
    } else {
      ref.read(goRouterProvider).go(LoginScreen.routeName);
    }*/
  }
}
