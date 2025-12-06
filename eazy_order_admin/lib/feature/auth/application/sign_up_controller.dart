
import 'package:core/core.dart';
import 'package:eazy_order_admin/core/routing/app_router.dart';
import 'package:eazy_order_admin/feature/auth/entity/signup_entity.dart';
import 'package:eazy_order_admin/feature/auth/repository/signup_repository.dart';
import 'package:eazy_order_admin/feature/business/presentations/screens/add_business_screen.dart';
import 'package:eazy_order_admin/feature/main_screen/presentations/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_controller.g.dart'; // Required for code generation

@Riverpod(keepAlive: true)
class SignUpController extends _$SignUpController {

  @override
  SignupEntity build() {
    ref.keepAlive();
    return SignupEntity();
  }

  void onFullNameChange(String val) {
    state = state.copyWith(
      fullName: val.trim()
    );
    onStep1Validate();
  }

  void onEmailChange(String val) {
    state = state.copyWith(
      email: val.trim()
    );
    onStep1Validate();
  }

  void onMobileChange(String val) {
    state = state.copyWith(
      mobile: val.trim()
    );
    onStep1Validate();
  }

  void onAgreeChange(bool val) {
    state = state.copyWith(
      isAgree: val
    );
    onStep1Validate();
  }

  void onOtpEmailChange(String val) {
    state = state.copyWith(
      otpEmail: val.trim()
    );
    onStep2Validate();
  }

  void onOtpPhoneChange(String val) {
    state = state.copyWith(
      otpPhone: val.trim()
    );
    onStep2Validate();
  }

  void onPasswordChange(String val) {
    state = state.copyWith(
      password: val.trim()
    );
    onStep3Validate();
  }

  void onConfirmPasswordChange(String val) {
    state = state.copyWith(
      confirmPass: val.trim()
    );
    onStep3Validate();
  }

  void onStep1Validate() {
    state = state.copyWith(
      isStep1Validated: state.fullName.isNotEmpty && state.email.isValidEmail && state.mobile.isValidIndianMobile && state.isAgree
    );
  }

  void onStep2Validate() {
    state = state.copyWith(
      isStep2Validated: state.otpEmail.length == AppConsts.otpLength && state.otpPhone.length == AppConsts.otpLength
    );
  }

  void onStep3Validate() {
    state = state.copyWith(
      isStep3Validated: state.password.isNotEmpty && state.password == state.confirmPass
    );
  }

  void onStep1NextClick() async {
    state = state.copyWith(isLoading1: true);
    final result = await _isUserAlreadyExists();
    if (result) {
      state = state.copyWith(isLoading1: false);
      return;
    }
    final signupRepo = ref.read(signupRepositoryProvider);
    await signupRepo.sendPhoneOtp('+91${state.mobile}');
    state = state.copyWith(
      currentStep: 2,
      isLoading1: false,
    );
  }

  void onStep2NextClick() async {
    state = state.copyWith(isLoading2: true);
    final signupRepo = ref.read(signupRepositoryProvider);
    final result = await signupRepo.loginWithPhone(state.verificationId, state.otpPhone);
    state = result.fold((l) {
      ToastUtils.error(l);
      state = state.copyWith(
        isLoading2: false
      );
      return state;
    }, (r) {
      state = state.copyWith(
        currentStep: 3,
        isLoading2: false
      );
      return state;
    });

  }

  void onSignupClick() async {
    state = state.copyWith(isLoading3: true);
    final signupRepo = ref.read(signupRepositoryProvider);
    final result = await signupRepo.userSignup({
      'email': state.email,
      'name': state.fullName,
      'mobile': state.mobile,
      'password': state.password,
    });
    state = result.fold((l) {
      ToastUtils.error(l);
      state = state.copyWith(
        isLoading3: false
      );
      return state;
    }, (r) {
      state = state.copyWith(
          currentStep: 1,
          isLoading3: false
      );
      ref.read(goRouterProvider).go(AddBusinessScreen.routeName);
      return state;
    });
  }

  Future<bool> _isUserAlreadyExists() async {
    final signupRepo = ref.read(signupRepositoryProvider);
    final result = await signupRepo.isUserExists(state.email, state.mobile);
    if (result.isLeft) {
      return false;
    } else {
      if (result.right) {
        ToastUtils.error('Email is already exists');
      } else {
        ToastUtils.error('Mobile is already exists');
      }
      return true;
    }
  }
}
