
import 'package:eazy_order_pro/feature/auth/presentations/screens/login_screen.dart';
import 'package:eazy_order_pro/feature/auth/presentations/screens/register_screen.dart';
import 'package:eazy_order_pro/feature/catalog/presentation/screen/Order_screen.dart';
import 'package:eazy_order_pro/feature/catalog/presentation/screen/cart_screen.dart';
import 'package:eazy_order_pro/feature/catalog/presentation/screen/order_details_screen.dart';
import 'package:eazy_order_pro/feature/catalog/presentation/screen/product_listing_screen.dart';
import 'package:eazy_order_pro/feature/home/presentations/screens/home_screen.dart';
import 'package:eazy_order_pro/feature/splash_screen.dart';
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
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/product_listing',
        builder: (context, state) => const ProductListingScreen(),
      ),
      GoRoute(
        path: '/cartscreen',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/orderscreen',
        builder: (context, state) => const OrderScreen(),
      ),
      GoRoute(
          path: '/order-details',
          builder: (context, state) => const OrderDetailsScreen(),
      ),
    ],
  );
});
