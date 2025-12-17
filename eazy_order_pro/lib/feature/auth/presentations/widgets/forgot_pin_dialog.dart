/*

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:core/core.dart';
import 'package:jiinue/core/config/app_colors.dart' as colors;
import 'package:jiinue/core/routing/app_router.dart';
import 'package:jiinue/feature/auth/applications/sign_up_controller.dart';
import 'package:jiinue/feature/auth/presentations/screens/sign_up_screen.dart';

class ForgotPinDialog extends ConsumerStatefulWidget {
  const ForgotPinDialog({super.key});

  @override
  ConsumerState<ForgotPinDialog> createState() => _ForgotPinDialogState();
}

class _ForgotPinDialogState extends ConsumerState<ForgotPinDialog> {

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
        height: 401.h,
        width: 429.w,
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(30.r)
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 29.w, right: 29.5.w),
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
              SizedBox(height: 34.79.h,),
              Text(
                'Forgot PIN',
                style: GoogleFonts.interTight(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.label1
                ),
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 12.h,),
              Text(
                'Enter your mobile number, we’ll send you a One Time Password (OTP) in order to reset your PIN',
                style: GoogleFonts.interTight(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w300,
                    color: AppColors.black
                ),
              ),
              SizedBox(height: 17.h,),
              Text(
                'Phone',
                style: GoogleFonts.interTight(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.label1
                ),
              ),
              SizedBox(height: 6.h,),
              Row(
                children: [
                  CountryPickerWidget(),
                  SizedBox(width: 10.w,),
                  Container(
                    height: 50.h,
                    width: 248.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(
                            color: AppColors.background2
                        ),
                        color: AppColors.background3
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '000-000-0000',
                        hintStyle: GoogleFonts.interTight(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.label1.withAlpha(128)
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.background3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.borderColor),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 15.h),
                      ),
                      style: GoogleFonts.interTight(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.label1
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h,),
              AppButton(
                text: 'Proceed',
                height: 60.h,
                borderRadius: 12.r,
                color: colors.AppColors.primaryColorDark,
                disabledColor: AppColors.background4,
                textStyle: GoogleFonts.interTight(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white
                ),
                onPressed: state.isValid ? () {

                } : null,
              ),
              SizedBox(height: 26.h,),
              RichText(
                text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'Not have an account?',
                          style: GoogleFonts.interTight(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w300,
                              color: AppColors.label1
                          )
                      ),
                      TextSpan(
                          text: ' Sign-Up ',
                          style: GoogleFonts.interTight(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: colors.AppColors.primaryColor
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            ref.read(goRouterProvider).pop();
                            ref.read(goRouterProvider).push(SignUpScreen.routeName);
                          }
                      )
                    ]
                ),
              ),
              SizedBox(height: 32.h,),
              SizedBox(height: MediaQuery.of(context).viewPadding.bottom,),
            ],
          ),
        ),
      ),
    );
  }
}
*/
