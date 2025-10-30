
import 'dart:async';

import 'package:core/core.dart';
import 'package:eazy_order_web/core/routing/app_router.dart';
import 'package:eazy_order_web/feature/home/presentations/screens/mobile/product_listing_screen.dart';
import 'package:eazy_order_web/feature/home/presentations/screens/web/qr_not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      color: Colors.grey.shade50,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: AppConsts.webAppWidth),
        child: _commonUI(),
      ),
    );
  }

  Widget _commonUI() {
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
    //String businessId = "eaf5a2b4-eb59-40f1-9ef9-bca4fbc4158c";
    //String businessId = "70fe4769-fe80-4d4d-b84d-c09f7917cdb5";
    //AppConsts.setBusinessId = "eaf5a2b4-eb59-40f1-9ef9-bca4fbc4158c";
    //AppConsts.setBusinessId = "c9fda2e3-2c7d-430b-a2d4-73adaa0f56a1"; // Demo Shop
    AppConsts.setBusinessId = "eb011c87-43f9-4fe9-9bd5-0b417970f1f4"; // Neo Sports Store
    //AppConsts.setBusinessId = "6ae27183-4c61-4a50-9991-58244ea3f40b"; // Test 1
    if (AppConsts.businessId.isNotEmpty) {
      ref.read(goRouterProvider).go('${ProductListingScreen.routeName}/${AppConsts.businessId}');
    } else {
      ref.read(goRouterProvider).go(QRNotFoundScreen.routeName);
      Fluttertoast.showToast(
          msg: 'Scan the QR Code again...!',
          toastLength: Toast.LENGTH_LONG,
          webPosition: "center"
      );
    }
  }
}
