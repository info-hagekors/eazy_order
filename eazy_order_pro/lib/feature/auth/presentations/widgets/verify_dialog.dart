/*

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:core/core.dart';
import 'package:jiinue/core/config/app_colors.dart' as colors;
import 'package:jiinue/core/routing/app_router.dart';
import 'package:jiinue/feature/auth/applications/sign_up_controller.dart';
import 'package:jiinue/feature/auth/presentations/widgets/verify_success_dialog.dart';
import 'package:jiinue/feature/home/presentations/screens/home_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyDialog extends ConsumerStatefulWidget {
  const VerifyDialog({super.key, required this.mobile, required this.countryCode});

  final String mobile;
  final String countryCode;

  @override
  ConsumerState<VerifyDialog> createState() => _VerifyDialogState();
}

class _VerifyDialogState extends ConsumerState<VerifyDialog> {

  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpControllerProvider);
    otpController.text = state.enteredOtp;
    String text = switch(state.otpRetryCount) {
      0 => 'Did not receive the code? ',
      1 => 'Wrong code, ',
      2 => 'Wrong code, ',
      3 => 'Too many tries, ',
      _ => ''
    };
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: 832.h,
        width: 429.w,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30.r)
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h,),
              Center(
                child: Container(
                  height: 3.h,
                  width: 60.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColors.dragIconColor,
                      borderRadius: BorderRadius.circular(2.5)
                  ),
                ),
              ),
              SizedBox(height: 40.h,),
              Padding(
                padding: EdgeInsets.only(left: 28.99.w),
                child: Text(
                  'Verify your ${state.isSignupWithEmail ? 'email' : 'number'}',
                  style: GoogleFonts.interTight(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.label1
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: 7.h,),
              Padding(
                padding: EdgeInsets.only(left: 28.99.w),
                child: Text(
                  'We sent the verification code ${state.isSignupWithEmail ? 'to:' : 'on number:'}',
                  style: GoogleFonts.interTight(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.label1
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 28.99.w),
                child: Text(
                  state.isSignupWithEmail ? state.email.scramble(start: 3, limit: 6) :
                  '${widget.countryCode} ${widget.mobile.scramble()}',
                  style: GoogleFonts.interTight(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.label1
                  ),
                ),
              ),
              SizedBox(height: 55.h,),
              Container(
                padding: EdgeInsets.only(left: 29.w, right: 30.w),
                child: PinCodeTextField(
                  appContext: context,
                  length: 5,
                  controller: otpController,
                  hintCharacter: '*',
                  pinTheme: PinTheme(
                    borderWidth: 3.h,
                    fieldWidth: 50.h,
                    activeColor: state.otpRetryCount > 0 ? AppColors.error : AppColors.borderColor1,
                    activeFillColor: AppColors.borderColor1,
                    inactiveColor: state.otpRetryCount > 0 ? AppColors.error : AppColors.borderColor1,
                    selectedColor: AppColors.borderColor1,
                    shape: PinCodeFieldShape.underline
                  ),
                  animationType: AnimationType.none,
                  showCursor: true,
                  cursorColor: AppColors.borderColor1,
                  textStyle: GoogleFonts.interTight(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black
                  ),
                  hintStyle: GoogleFonts.interTight(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black
                  ),
                  keyboardType: TextInputType.none,
                  onCompleted: (val) {
                    ref.read(signUpControllerProvider.notifier).onVerifyOtp(val, onVerifyComplete: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return VerifySuccessDialog(
                              title: state.isSignupWithEmail ? 'Email verified' : 'Phone number verified',
                              subTitle: state.isSignupWithEmail ? 'Email verified. Thank you for registering!' : 'Phone number verified. Thank you for registering!',
                              icon: AppImages.icVerifySuccess,
                            );
                          }
                      ).then((val) {
                        ref.read(goRouterProvider).go(HomeScreen.routeName);
                      });
                    });
                  },
                ),
              ),
              SizedBox(height: 37.5.h,),
              if (state.otpRetryCount == 0) ... [
                Center(
                  child: RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'Code expires in ',
                              style: GoogleFonts.interTight(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.label1.withAlpha(128)
                              )
                          ),
                          TextSpan(
                              text: '00:15',
                              style: GoogleFonts.interTight(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.label1
                              )
                          )
                        ]
                    ),
                  ),
                ),
                SizedBox(height: 14.h,),
              ],
              Center(
                child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: text,
                            style: GoogleFonts.interTight(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.label1
                            )
                        ),
                        TextSpan(
                            text: state.otpRetryCount > 2 ? 'Start over' : 'Send Again',
                            style: GoogleFonts.interTight(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: colors.AppColors.primaryColor
                            )
                        )
                      ]
                  ),
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 24.h, width: 24.w,
                      margin: EdgeInsets.only(top: 3.h),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(15),
                            blurRadius: 7,
                            spreadRadius: 0.5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(AppImages.icCheckWithShadow, height: 24.h, width: 24.w,)
                  ),
                  SizedBox(width: 10.w,),
                  Text(
                      "Secure Keyboard",
                    style: GoogleFonts.interTight(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.label2
                    ),
                  ),
                ],
              ),
              SizedBox(height: 33.h,),
              Padding(
                padding: EdgeInsets.only(left: 30.36.w, right: 15.64.w),
                child: SecureKeyboard(onKeyTap: (key, isBack, isEnter) {
                  String result = ref.read(signUpControllerProvider.notifier).onEnterOtp(key, isBack);
                  otpController.text = result;
                }),
              ),
              SizedBox(height: 31.75.h,),
            ],
          ),
        ),
      ),
    );
  }
}
*/
