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
    SizedBox(),
    SizedBox(),
    SizedBox(),
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: state.selectedPage,
        selectedItemColor: AppColors.primaryColor,   // Replace with AppColors.primaryColor
        unselectedItemColor: AppColors.background2,
        elevation: 0,
        onTap: ref.read(homeControllerProvider.notifier).onPageChange,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_applications_sharp),
            label: "RoadConfig",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dataset_outlined),
            label: "Live Data",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logo_dev),
            label: "Log",
          ),
        ],
      ),
      body: _pages[state.selectedPage],
    );
  }
}
