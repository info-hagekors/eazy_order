import 'package:core/config/app_colors.dart';
import 'package:core/widgets/app_button.dart';
import 'package:core/widgets/common_text_field.dart';
import 'package:eazy_order_pro/feature/auth/applications/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  static const String routeName = '/register';

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.read(registerControllerProvider.notifier);
    final state = ref.watch(registerControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 20.h),

              Text(
                "Let's Get start!",
                style: GoogleFonts.poppins(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),

              SizedBox(height: 30.h),

              SizedBox(
                height: 65.h,
                child: CommonTextField(
                  width: double.infinity,
                  hintText: 'Business Name',
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black
                  ),
                  onChanged: controller.onBusinessNameChanged,
                ),
              ),

              SizedBox(height: 16.h),

              SizedBox(
                height: 65.h,
                child: CommonTextField(
                  width: double.infinity,
                  hintText: 'Email',
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: controller.onEmailChanged,
                ),
              ),

              SizedBox(height: 16.h),

              SizedBox(
                height: 65.h,
                child: CommonTextField(
                  width: double.infinity,
                  hintText: 'Mobile',
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: controller.onMobileChanged,
                ),
              ),

              SizedBox(height: 16.h),

              SizedBox(
                height: 65.h,
                child: CommonTextField(
                  width: double.infinity,
                  hintText: 'GST number (optional)',
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: controller.onGSTNoChanged,
                ),
              ),

              SizedBox(height: 16.h),

              SizedBox(
                height: 65.h,
                child: CommonTextField(
                  width: double.infinity,
                  hintText: 'Password',
                  hintStyle: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black
                  ),
                  isObscureText: true,
                  onChanged: controller.onPasswordChanged,
                ),
              ),

              SizedBox(height: 16.h),

              SizedBox(
                height: 65.h,
                child: CommonTextField(
                  width: double.infinity,
                  hintText: 'Confirm Password',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                  isObscureText: true,
                  onChanged: controller.onConfirmPassChanged,
                ),
              ),

              SizedBox(height: 30.h),

              SizedBox(
                width: double.infinity,
                child: AppButton(
                  height: 70.h,
                  color: AppColors.borderColor,
                  onPressed: () => controller.onRegister(),
                  text: 'Sign Up',
                  textStyle: GoogleFonts.poppins(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white
                  ),
                  borderRadius: 18.r,
                ),
              ),

              SizedBox(height: 30.h),

              Center(
                child: Column(mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have account?",
                          style: GoogleFonts.poppins(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black
                          ),
                        ),
                        InkWell(
                          onTap: (){},
                          child: Text(" Log In",
                            style: GoogleFonts.poppins(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.confirm
                            ),),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
