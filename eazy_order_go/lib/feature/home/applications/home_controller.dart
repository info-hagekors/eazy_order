

import 'package:core/core.dart';
import 'package:eazy_order_go/core/routing/app_router.dart';
import 'package:eazy_order_go/core/services/secure_storage_service.dart';
import 'package:eazy_order_go/feature/auth/presentation/screens/splash_screen.dart';
import 'package:eazy_order_go/feature/auth/repository/auth_repository.dart';
import 'package:eazy_order_go/feature/home/applications/category_controller.dart';
import 'package:eazy_order_go/feature/home/applications/order_controller.dart';
import 'package:eazy_order_go/feature/home/entities/home_entity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_controller.g.dart'; // Required for code generation

@Riverpod(keepAlive: true)
class HomeController extends _$HomeController {

  @override
  HomeEntity build() {
    ref.keepAlive();
    return HomeEntity();
  }

  void getBusinessData(BuildContext? context) async {
    await Future.delayed(Duration(milliseconds: 50));
    if (context != null) {
      showLoading(context);
    }
    final mobile = await ref.read(secureStorageServiceProvider).getMobile();
    BusinessModel business = await ref.read(authRepositoryProvider).getBusinessByMobile(mobile);
    state = state.copyWith(businessModel: business);
    if (context != null) {
      ref.read(goRouterProvider).pop();
    }
    if (business.businessId.isNotEmpty) {
      ref.read(orderControllerProvider.notifier).getTodayOrders(business.businessId);
      await ref.read(categoryControllerProvider.notifier).getAllCategories(business.businessId);
    }
  }

  void updatePageIndex(int val) {
    state = state.copyWith(selectedIndex: val);
  }

  void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from closing it
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: AppColors.black.withAlpha(56),
          body: Center(
            child: CircularProgressIndicator(color: AppColors.imageBgColor),
          ),
        );
      },
    );
  }

  void logout() async {
    try {
      await ref.read(secureStorageServiceProvider).deleteAll();
      ref.read(goRouterProvider).go(SplashScreen.routeName);
      updatePageIndex(0);
    } catch (e) {
      debugPrint('Logout error: $e');
      Fluttertoast.showToast(msg: 'Logout failed. Please try again.');
    }
  }
}
