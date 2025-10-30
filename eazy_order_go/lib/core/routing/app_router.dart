import 'package:eazy_order_go/feature/auth/presentation/screens/login_screen.dart';
import 'package:eazy_order_go/feature/auth/presentation/screens/splash_screen.dart';
import 'package:core/core.dart';
import 'package:eazy_order_go/feature/business/presentations/screens/business_setup_screen.dart';
import 'package:eazy_order_go/feature/business/presentations/screens/welcome_screen.dart';
import 'package:eazy_order_go/feature/home/presentations/screens/cart_screen.dart';
import 'package:eazy_order_go/feature/home/presentations/screens/home_screen.dart';
import 'package:eazy_order_go/feature/home/presentations/screens/new_order_screen.dart';
import 'package:eazy_order_go/feature/home/presentations/screens/qr_code_screen.dart';
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
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/business_setup',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          BusinessModel business = BusinessModel.fromJson(args);
          return BusinessSetupScreen(business: business);
        },
      ),
      GoRoute(
        path: '/qr_code',
        builder: (context, state) => const QrCodeScreen(),
      ),
      GoRoute(
        path: '/new_order',
        builder: (context, state) => const NewOrderScreen(),
      ),
      GoRoute(
        path: '/cart/:businessId',
        builder: (context, state) {
          final businessId = state.pathParameters['businessId']!;
          return CartScreen(businessId: businessId,);
        },
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          BusinessModel business = BusinessModel.fromJson(args);
          return WelcomeScreen(business: business,);
        },
      ),
    ],
  );
});
