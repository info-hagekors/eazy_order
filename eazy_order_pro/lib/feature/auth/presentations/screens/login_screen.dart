
import 'package:core/widgets/app_button.dart';
import 'package:core/widgets/common_text_field.dart';
import 'package:eazy_order_pro/core/config/app_colors.dart';
import 'package:eazy_order_pro/core/config/app_images.dart';
import 'package:eazy_order_pro/feature/auth/applications/login_controller.dart';
import 'package:eazy_order_pro/feature/auth/entities/login_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);
    final controller = ref.read(loginControllerProvider.notifier);
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: EdgeInsets.only(left: 28.w, right: 28.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: MediaQuery.of(context).padding.top,),
                      Container(
                        width: 250.w,
                        height: 250.h,
                        alignment: Alignment.center,
                        child: Image.asset(AppImages.appLogo),
                      ),
                      SizedBox(height: 12.h,),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Login',
                          style: GoogleFonts.poppins(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black
                          ),
                        ),
                      ),
                      //SizedBox(height: 4.h,),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Select Login type to continue',
                          style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.label1
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h,),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.r),
                            color: AppColors.background
                        ),
                        height: 52.h,
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => controller.onLoginMethodChange(true),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.r),
                                      color: state.isLoginWithEmail ? AppColors.background2 : null
                                  ),
                                  child: Text(
                                    'Email',
                                    style: GoogleFonts.poppins(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => controller.onLoginMethodChange(false),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.r),
                                      color: state.isLoginWithEmail ? null : AppColors.background2
                                  ),
                                  child: Text(
                                    'Mobile',
                                    style: GoogleFonts.poppins(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      if (state.isLoginWithEmail) ... [
                        _loginWithEmail(state),
                      ] else ... [
                        _loginWithOTP(state),
                      ],
                      SizedBox(height: 24.h,),
                      AppButton(
                        text: 'Login',
                        height: 60.h,
                        borderRadius: 12.r,
                        color: AppColors.primaryColor,
                        disabledColor: AppColors.background4,
                        textStyle: GoogleFonts.poppins(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white
                        ),
                        onPressed: () {
                          ref.read(loginControllerProvider.notifier).userLogin(context);
                          //ref.read(loginControllerProvider.notifier).showOtpDialog(context);
                        },
                      ),
                      SizedBox(height: 32.h,),
                    ],
                  ),
                ),
              ),
              Text(
                '© Powered by Hagekors Technolabs',
                style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black
                ),
              ),
              SizedBox(height: 12.h,),
              SizedBox(height: MediaQuery.of(context).padding.bottom,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginWithEmail(LoginEntity state) {
    return Column(
      children: [
        SizedBox(height: 12.h,),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
              'Email',
              style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.label1
              )
          ),
        ),
        SizedBox(height: 6.h,),
        CommonTextField(
          onChanged: ref.read(loginControllerProvider.notifier).onEmailChanged,
          hintText: 'Example: abc@gmail.com',
        ),
        SizedBox(height: 16.h,),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Password',
            style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.label1
            ),
          ),
        ),
        SizedBox(height: 6.h,),
        CommonTextField(
          onChanged: ref.read(loginControllerProvider.notifier).onPasswordChanged,
          hintText: '...',
          suffixIcon: IconButton(
            onPressed: () => ref.read(loginControllerProvider.notifier).showPassword(),
            icon: state.isPasswordVisible ? SvgPicture.asset(AppImages.icEyeOff) : SvgPicture.asset(AppImages.icEyeOn),
          ),
          isObscureText: !state.isPasswordVisible,
        ),
        SizedBox(height: 4.h,),
        Container(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => ref.read(loginControllerProvider.notifier).navigateToForgotPassword(),
            child: Text(
              'Forgot Password',
              style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.primaryColor,
                  decoration: TextDecoration.underline
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _loginWithOTP(LoginEntity state) {
    return Column(
      children: [
        SizedBox(height: 12.h,),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
              'Mobile Number',
              style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.label1
              )
          ),
        ),
        SizedBox(height: 6.h,),
        CommonTextField(
          onChanged: ref.read(loginControllerProvider.notifier).onMobileChanged,
          hintText: 'Example: +91 9876543210',
        ),
      ],
    );
  }
}
