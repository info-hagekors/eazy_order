
import 'package:core/core.dart';
import 'package:eazy_order_go/feature/auth/applications/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
    //final state = ref.watch(signUpControllerProvider);
    //otpController.text = state.enteredOtp;
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: 732.h,
        width: 429.w,
        decoration: BoxDecoration(
          color: AppColors.screenBgColor,
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
                      color: AppColors.black.withAlpha(128),
                      borderRadius: BorderRadius.circular(2.5)
                  ),
                ),
              ),
              SizedBox(height: 40.h,),
              Padding(
                padding: EdgeInsets.only(left: 28.99.w),
                child: Text(
                  'Verify your mobile number',
                  style: GoogleFonts.interTight(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(height: 7.h,),
              Padding(
                padding: EdgeInsets.only(left: 28.99.w),
                child: Text(
                  'We have sent the verification code on number:',
                  style: GoogleFonts.interTight(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 28.99.w),
                child: Text(
                  '+91 ${widget.mobile}',
                  style: GoogleFonts.interTight(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black
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
                    fieldWidth: 60.h,
                    activeColor: AppColors.borderColor,
                    activeFillColor: AppColors.borderColor,
                    inactiveColor: AppColors.borderColor,
                    selectedColor: AppColors.borderColor,
                    shape: PinCodeFieldShape.circle,
                  ),
                  animationType: AnimationType.none,
                  showCursor: false,
                  cursorColor: AppColors.borderColor,
                  textStyle: GoogleFonts.interTight(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                  hintStyle: GoogleFonts.interTight(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black
                  ),
                  keyboardType: TextInputType.none,
                  onCompleted: (val) {
                    ref.read(loginControllerProvider.notifier).onValidateOtp();
                  },
                ),
              ),
              SizedBox(height: 37.5.h,),
              Center(
                child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'Code expires in ',
                            style: GoogleFonts.interTight(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.black.withAlpha(128)
                            )
                        ),
                        TextSpan(
                            text: '00:15',
                            style: GoogleFonts.interTight(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black
                            )
                        )
                      ]
                  ),
                ),
              ),
              SizedBox(height: 14.h,),
              Spacer(),
              SizedBox(height: 33.h,),
              Padding(
                padding: EdgeInsets.only(left: 30.36.w, right: 15.64.w),
                child: SecureKeyboard(onKeyTap: (key, isBack, isEnter) {
                  if (!isEnter) {
                    String result = ref.read(loginControllerProvider.notifier).onEnterOtp(key, isBack);
                    otpController.text = result;
                  }
                }),
              ),
              SizedBox(height: 31.75.h,),
              SizedBox(height: AppConsts.bottomPadding,),
            ],
          ),
        ),
      ),
    );
  }
}
