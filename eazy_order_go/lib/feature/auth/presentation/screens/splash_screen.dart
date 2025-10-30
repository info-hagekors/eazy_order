import 'dart:async';

import 'package:core/core.dart';
import 'package:eazy_order_go/core/routing/app_router.dart';
import 'package:eazy_order_go/core/services/secure_storage_service.dart';
import 'package:eazy_order_go/feature/auth/applications/login_controller.dart';
import 'package:eazy_order_go/feature/auth/presentation/screens/login_screen.dart';
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
    _checkForUpdates();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3500),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.imageBgColor,
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
              width: 200.w,
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

  void _checkForUpdates() async {
    await Future.delayed(const Duration(seconds: 3));
    final mobile = await ref.read(secureStorageServiceProvider).getMobile();
    if (mobile.isNotEmpty) {
      ref.read(loginControllerProvider.notifier).getBusinessByMobile(mobile);
    } else {
      ref.read(goRouterProvider).go(LoginScreen.routeName);
    }
  }
}
