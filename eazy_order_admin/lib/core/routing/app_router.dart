
import 'package:eazy_order_admin/feature/auth/presentation/screens/sign_in_screen.dart';
import 'package:eazy_order_admin/feature/auth/presentation/screens/sign_up_screen.dart';
import 'package:eazy_order_admin/feature/business/presentations/screens/add_business_screen.dart';
import 'package:eazy_order_admin/feature/main_screen/presentations/screens/main_screen.dart';
import 'package:eazy_order_admin/feature/splash_screen.dart';
import 'package:eazy_order_admin/feature/user/presentations/screens/user_screen.dart';
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
        path: '/sign_in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/sign_up',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/main_screen',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          final businessId = args['business_id'] ?? '';
          return MainScreen(businessId: businessId);
        },
      ),
      GoRoute(
        path: '/add_business',
        builder: (context, state) {
          return AddBusinessScreen();
        },
      ),
    ],
  );
});
