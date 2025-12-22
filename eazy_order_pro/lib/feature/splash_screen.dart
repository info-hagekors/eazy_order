
import 'dart:async';

import 'package:core/core.dart';
import 'package:eazy_order_pro/core/routing/app_router.dart';
import 'package:eazy_order_pro/feature/auth/presentations/screens/login_screen.dart';
import 'package:eazy_order_pro/feature/home/presentations/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/splash';

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    //checkUserStatus();
    navigate();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppConsts.isWeb ? _webUI() : _commonUI();
  }

  Widget _webUI() {
    return Container(
      alignment: Alignment.center,
      color: AppColors.grey50,
      child: _commonUI(),
    );
  }

  Widget _commonUI() {
    return Scaffold(
      body: Container(
        color: AppColors.white,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 304.h,),
            Container(
              height: 300.h,
              width: 300.w,
              alignment: Alignment.center,
              child: Image.asset(
                AppImages.splashLogo,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 200.h,),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  border: Border.all(
                      color: AppColors.primaryColor,
                      width: 2.w
                  )
              ),
              height: 10.h,
              width: AppConsts.isWeb ? 200 : 200.w,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    color: AppColors.primaryColor,
                    backgroundColor: AppColors.imageBgColor,
                    minHeight: 4.h,
                    borderRadius: BorderRadius.circular(5.r),
                    value: _controller.value,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void navigate() async {
    await Future.delayed(Duration(seconds: 2));
    if (ref.read(authServiceProvider).checkCurrentUser()) {
      ref.read(goRouterProvider).go(HomeScreen.routeName);
    } else {
      ref.read(goRouterProvider).go(LoginScreen.routeName);
    }
  }

  void checkUserStatus() {
    ref.read(authServiceProvider).userStream.listen((user) {
      if (user == null) {
        ref.read(goRouterProvider).go(LoginScreen.routeName);
      }
    });
  }
}
