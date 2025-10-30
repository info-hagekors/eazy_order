
import 'package:eazy_order_go/core/routing/app_router.dart';
import 'package:eazy_order_go/core/services/firebase_functions_service.dart';
import 'package:eazy_order_go/core/services/firebase_notification_service.dart';
import 'package:eazy_order_go/core/services/secure_storage_service.dart';
import 'package:eazy_order_go/feature/auth/entities/login_entity.dart';
import 'package:eazy_order_go/feature/auth/repository/auth_repository.dart';
import 'package:core/core.dart';
import 'package:eazy_order_go/feature/business/presentations/screens/welcome_screen.dart';
import 'package:eazy_order_go/feature/business/repository/business_setup_repository.dart';
import 'package:eazy_order_go/feature/home/presentations/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_controller.g.dart'; // Required for code generation

@riverpod
class LoginController extends _$LoginController {

  final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  final mobilePattern = RegExp(r'^[5-9]\d{9}$');

  @override
  LoginEntity build() {
    return LoginEntity();
  }

  void onMobileChanged(String val) {
    state = state.copyWith(mobile: val.trim());
    onValidate();
  }

  void onValidate() {
    bool isMobileValid = state.mobile.length == 10 && mobilePattern.hasMatch(state.mobile);
    state = state.copyWith(isValid: isMobileValid);
  }

  Future<bool> onSendOtp() async {
    state = state.copyWith(isLoading: true);
    final functionRepo = ref.read(firebaseFunctionsServiceProvider);
    final Map<String, dynamic> result = await functionRepo.sendOtp(state.mobile);
    state = state.copyWith(isLoading: false);
    if (result['success'] ?? false) {
      return true;
    } else {
      Fluttertoast.showToast(msg: result['message'] ?? 'Something went wrong');
      return false;
    }
  }

  String onEnterOtp(String key, bool isBack) {
    if (isBack) {
      if (state.enteredOtp.isNotEmpty) {
        final val = state.enteredOtp;
        state = state.copyWith(enteredOtp: val.substring(0, val.length - 1));
      }
    } else if (state.enteredOtp.length < 5) {
      String enteredOTP = state.enteredOtp;
      state = state.copyWith(enteredOtp: enteredOTP + key);
    }
    return state.enteredOtp;
  }

  void onValidateOtp() async {
    final functionRepo = ref.read(firebaseFunctionsServiceProvider);
    final Map<String, dynamic> result = await functionRepo.verifyOtp(state.mobile, state.enteredOtp);
    if (result['success'] ?? false) {
      await ref.read(secureStorageServiceProvider).storeMobile('91${state.mobile}');
      try {
        final mobile = await ref.read(secureStorageServiceProvider).getMobile();
        final businessRepo = ref.read(businessSetupRepositoryProvider);
        await businessRepo.updateBusinessFcmToken(mobile, FirebaseNotificationService.token);
      } catch (e) {
        debugPrint(e.toString());
      }
      ref.read(goRouterProvider).pop(true);
    } else {
      state = state.copyWith(enteredOtp: '');
      ref.read(goRouterProvider).pop(false);
      Fluttertoast.showToast(msg: result['message'] ?? 'Something went wrong');
    }
  }

  void getBusinessByMobile(String mobile) async {
    final authRepo = ref.read(authRepositoryProvider);
    BusinessModel business = await authRepo.getBusinessByMobile(mobile);
    if (business.isSetupCompleted) {
      ref.read(goRouterProvider).go(HomeScreen.routeName);
    } else {
      final business = BusinessModel(logo: '', name: '', businessId: '', mobile: mobile);
      ref.read(goRouterProvider).go(WelcomeScreen.routeName, extra: business.toMap());
    }
  }
}
