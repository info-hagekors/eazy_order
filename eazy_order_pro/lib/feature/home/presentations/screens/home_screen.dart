import 'package:eazy_order_pro/feature/catalog/presentation/screen/Order_screen.dart';
import 'package:eazy_order_pro/feature/catalog/presentation/screen/product_listing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eazy_order_pro/core/config/app_colors.dart';
import 'package:eazy_order_pro/feature/home/applications/home_controller.dart';
import 'package:eazy_order_pro/feature/home/presentations/screens/dashboard_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  // Pages for each tab
  final List<Widget> _pages = const [
    DashboardScreen(),
    ProductListingScreen(),
    OrderScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: state.selectedPage,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.background4,
        elevation: 0,
        onTap: ref.read(homeControllerProvider.notifier).onPageChange,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_applications_sharp),
            label: "Catalogue",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reorder),
            label: "Order",
          ),
        ],
      ),
      body: _pages[state.selectedPage],
    );
  }
}
