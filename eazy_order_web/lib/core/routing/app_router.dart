import 'dart:convert';

import 'package:core/core.dart';
import 'package:eazy_order_web/feature/home/presentations/screens/mobile/cart_screen.dart';
import 'package:eazy_order_web/feature/home/presentations/screens/mobile/order_detail_screen.dart';
import 'package:eazy_order_web/feature/home/presentations/screens/mobile/product_listing_screen.dart';
import 'package:eazy_order_web/feature/home/presentations/screens/splash_screen.dart';
import 'package:eazy_order_web/feature/home/presentations/screens/web/cart_web_screen.dart';
import 'package:eazy_order_web/feature/home/presentations/screens/web/order_detail_web_screen.dart';
import 'package:eazy_order_web/feature/home/presentations/screens/web/product_listing_web_screen.dart';
import 'package:eazy_order_web/feature/home/presentations/screens/web/qr_not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/product_listing/:businessId',
        builder: (context, state) {
          final businessId = state.pathParameters['businessId']!;
          return AppConsts.isWeb ? ProductListingWebScreen(businessId: businessId)
              : ProductListingScreen(businessId: businessId,);
        },
      ),
      GoRoute(
        path: '/cart/:businessId',
        builder: (context, state) {
          final businessId = state.pathParameters['businessId']!;
          return AppConsts.isWeb ? CartWebScreen(businessId: businessId) : CartScreen(businessId: businessId,);
        },
      ),
      GoRoute(
        path: '/order_detail/:orderId',
        builder: (context, state) {
          final orderId = state.pathParameters['orderId']!;
          return AppConsts.isWeb ? OrderDetailWebScreen(orderId: orderId) : OrderDetailScreen(orderId: orderId,);
        },
      ),
      GoRoute(
        path: '/qr_scan',
        builder: (context, state) => const QRNotFoundScreen(),
      ),
    ],
  );
});
