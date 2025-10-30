
import 'package:core/core.dart';
import 'package:eazy_order_go/core/routing/app_router.dart';
import 'package:eazy_order_go/feature/business/presentations/screens/business_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key, required this.business});

  static const String routeName = '/welcome';
  final BusinessModel business;

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.welcomeBgColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Image.asset(
                AppImages.welcome,
                height: 300.h,
                width: 300.w,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 30.h,),
              Text(
                'Welcome to EazyOrder!',
                style: GoogleFonts.nunito(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.supporting
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h,),
              Text(
                "You're all set to get started. \nLet’s help you set up your business profile and start accepting orders in minutes.",
                style: GoogleFonts.nunito(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 36.h,),
              Spacer(flex: 2,),
              AppButton(
                text: 'Continue',
                onPressed: () {
                  ref.read(goRouterProvider).go(BusinessSetupScreen.routeName, extra: widget.business.toMap());
                },
                color: AppColors.primaryColor,
                textStyle: GoogleFonts.nunito(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white
                ),
              ),
              SizedBox(height: 24.h,),
              SizedBox(height: AppConsts.bottomPadding,),
            ],
          ),
        )
    );
  }
}
