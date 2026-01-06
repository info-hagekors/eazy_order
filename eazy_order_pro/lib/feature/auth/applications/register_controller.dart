
import 'package:core/models/business_model.dart';
import 'package:core/models/user_model.dart';
import 'package:core/repositories/business_repository.dart';
import 'package:core/services/auth_service.dart';
import 'package:core/utils/toast_utils.dart';
import 'package:core/widgets/loading_dialog.dart';
import 'package:eazy_order_pro/core/config/app_images.dart';
import 'package:eazy_order_pro/core/routing/app_router.dart';
import 'package:eazy_order_pro/feature/auth/entities/register_entity.dart';
import 'package:eazy_order_pro/feature/auth/presentations/screens/admin_pin_screen.dart';
import 'package:eazy_order_pro/feature/auth/presentations/screens/login_screen.dart';
import 'package:eazy_order_pro/feature/auth/presentations/widgets/verify_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'register_controller.g.dart'; // Required for code generation

@riverpod
class RegisterController extends _$RegisterController {

  final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  final gstRegex = RegExp(r"^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$");

  @override
  RegisterEntity build() {
    return RegisterEntity();
  }

  void onBusinessNameChanged(String val) {
    state = state.copyWith(businessName: val.trim());
    onValidate();
  }

  void onEmailChanged(String val) {
    state = state.copyWith(email: val.trim());
    onValidate();
  }

  void onMobileChanged(String val) {
    state = state.copyWith(mobile: val.trim());
    onValidate();
  }

  void onGSTNoChanged(String val) {
    state = state.copyWith(gstNo: val.trim());
    onValidate();
  }

  void onPasswordChanged(String val) {
    state = state.copyWith(password: val);
    onValidate();
  }

  void onConfirmPassChanged(String val) {
    state = state.copyWith(confirmPassword: val);
    onValidate();
  }

  bool isValidEmail(String email) {
    return emailRegex.hasMatch(email);
  }

  bool isValidGSTNo(String gstNo) {
    return gstNo.length == 15 && gstRegex.hasMatch(gstNo);
  }

  void showPassword() {
    state = state.copyWith(isPassVisible: !state.isPassVisible);
  }

  void showConfirmPassword() {
    state = state.copyWith(isConfirmPassVisible: !state.isConfirmPassVisible);
  }

  void onValidate() {
    bool isBusinessValid = (state.businessName.length > 3);
    bool isEmailValid = (state.email.isNotEmpty && isValidEmail(state.email));
    bool isMobileValid = (state.mobile.isNotEmpty && state.mobile.length == 10);
    bool isGstValid = state.gstNo.isEmpty || isValidGSTNo(state.gstNo);
    bool isPassValid = state.password.length > 3;
    bool isConfirmPassValid = state.password == state.confirmPassword;
    state = state.copyWith(isValid: isBusinessValid && isEmailValid && isMobileValid && isGstValid && isPassValid && isConfirmPassValid);
  }

  void onRegister() async {
    final authService = ref.read(authServiceProvider);
    showLoadingDialog(navigatorKey.currentContext!);
    final result = await authService.registerWithEmail(state.email, state.password);
    if (result.isLeft) {
      hideLoadingDialog(navigatorKey.currentContext!);
      ToastUtils.error(result.left);
      return;
    }
    if (result.isRight) {
      final model = UserModel(
        uid: result.right.uid,
        name: state.businessName,
        email: state.email,
        mobile: state.mobile,
        role: 'Admin',
        businessId: '',
        isEmailVerified: false,
        isMobileVerified: false,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
      await authService.saveUserDetailsToFirestore(model);
      BusinessModel business = BusinessModel(
        businessId: const Uuid().v4(),
        adminId: result.right.uid,
        name: state.businessName,
        mobile: state.mobile,
        address: '',
        registrationNo: state.gstNo,
        logo: '',
        isSetupCompleted: false,
        token: '',
        orderPreference: [],
        paymentOptions: [],
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );
      ref.read(businessRepositoryProvider).addNewBusiness(business);
      showLoginSuccessDialog(navigatorKey.currentContext!);
    }
    hideLoadingDialog(navigatorKey.currentContext!);
  }

  void showLoginSuccessDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return VerifySuccessDialog(
            title: 'Register successfully',
            subTitle: 'User verified. Redirecting you to next step',
            icon: AppImages.icTwoStepVerify,
          );
        }
    ).then((val) {
      if (val ?? false) {
        ref.read(goRouterProvider).go(AdminPinScreen.routeName);
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

  void onLoginPress() {
    ref.read(goRouterProvider).push(LoginScreen.routeName);
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
