
import 'package:animations/animations.dart';
import 'package:core/core.dart';
import 'package:eazy_order_go/core/routing/app_router.dart';
import 'package:eazy_order_go/feature/home/applications/home_controller.dart';
import 'package:eazy_order_go/feature/home/presentations/screens/catalog_screen.dart';
import 'package:eazy_order_go/feature/home/presentations/screens/order_screen.dart';
import 'package:eazy_order_go/feature/home/presentations/screens/qr_code_screen.dart';
import 'package:eazy_order_go/feature/home/presentations/screens/report_screen.dart';
import 'package:eazy_order_go/feature/home/presentations/screens/store_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  final List<Widget> _screens = [
    ReportScreen(),
    OrderScreen(),
    CatalogScreen(),
    StoreProfileScreen()
  ];

  @override
  void initState() {
    ref.read(homeControllerProvider.notifier).getBusinessData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Welcome to Eazy Order',
        titleStyle: GoogleFonts.nunito(
          fontSize: 24.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryColor,
        ),
        backgroundColor: AppColors.imageBgColor,
        showLeading: false,
        actions: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              //color: AppColors.bgColor
            ),
            child: IconButton(
              onPressed: () {
                ref.read(goRouterProvider).push(QrCodeScreen.routeName);
              },
              icon: Icon(Icons.qr_code_2, size: 24.h,),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: state.selectedIndex,
        onTap: ref.read(homeControllerProvider.notifier).updatePageIndex,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.accentColor,
        selectedLabelStyle: GoogleFonts.nunito(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryColor,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.accentColor,
        ),
        iconSize: 24,
        elevation: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            label: 'Analysis',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.layers),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Catalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Store',
          ),
        ],
      ),
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 400),
        reverse: state.selectedIndex == 0,
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          );
        },
        child: _screens[state.selectedIndex],
      ),
    );
  }

  void showFullScreenLoader(BuildContext context) {
    Future.delayed(Duration(milliseconds: 50)).then((val) {
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
    });
  }

}
