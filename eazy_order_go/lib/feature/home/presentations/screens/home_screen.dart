import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:animations/animations.dart';
import 'package:core/core.dart';
import 'package:eazy_order_go/core/routing/app_router.dart';
import 'package:eazy_order_go/feature/home/applications/home_controller.dart';
import 'package:eazy_order_go/feature/home/presentations/screens/catalog_screen.dart';
import 'package:eazy_order_go/feature/home/presentations/screens/order_screen.dart';
import 'package:eazy_order_go/feature/home/presentations/screens/qr_code_screen.dart';
import 'package:eazy_order_go/feature/home/presentations/screens/report_screen.dart';
import 'package:eazy_order_go/feature/home/presentations/screens/setting_screen.dart';
import 'package:eazy_order_go/feature/home/presentations/screens/store_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'help_and_support_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home';

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

  final List<Widget> _screens = [
    ReportScreen(),
    OrderScreen(),
    CatalogScreen(),
  ];

  @override
  void initState() {
    ref.read(homeControllerProvider.notifier).getBusinessData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeControllerProvider);
    final business = state.businessModel;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff6F4F37),
            Color(0xffD7C0AE),
            Color(0xffF1E3D3),
          ]
        )
      ),
      child: AdvancedDrawer(
        controller: _advancedDrawerController,
        backdropColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        openRatio: 0.65,
        childDecoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),

        // 🔹 Main Home Screen
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: AppColors.imageBgColor,
          appBar: CommonAppBar(
            title: 'Home',
            titleStyle: GoogleFonts.nunito(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
            backgroundColor: AppColors.imageBgColor,
            showLeading: true,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    splashColor: AppColors.primaryColor.withOpacity(0.2),
                    highlightColor: Colors.transparent,
                    onTap: _handleMenuButtonPressed,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ValueListenableBuilder<AdvancedDrawerValue>(
                        valueListenable: _advancedDrawerController,
                        builder: (_, value, __) {
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: Icon(
                              value.visible ? Icons.clear : Icons.menu,
                              key: ValueKey<bool>(value.visible),
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

            actions: [
              IconButton(
                onPressed: () {
                  ref.read(goRouterProvider).push(QrCodeScreen.routeName);
                },
                icon: Icon(Icons.qr_code_2, size: 24.h),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.selectedIndex,
            onTap: ref.read(homeControllerProvider.notifier).updatePageIndex,
            selectedItemColor: AppColors.primaryColor,
            unselectedItemColor: AppColors.bgColor2,
            selectedLabelStyle: GoogleFonts.nunito(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.nunito(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            iconSize: 24,
            elevation: 12,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.analytics_outlined),
                label: 'Analysis',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.layers), label: 'Order'),
              BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Catalog'),
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
        ),

        // 🔹 Drawer with full gradient (covering top & bottom)
        drawer: Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xff6F4F37),
                Color(0xffD7C0AE),
                Color(0xffF1E3D3),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: (business?.logo != null && business!.logo.isNotEmpty)
                            ? NetworkImage(business.logo)
                            :  AssetImage(AppImages.storeimage) as ImageProvider,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              business?.name ?? "Your Store",
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              business?.mobile ?? "",
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _drawerItem(
                          icon: Icons.storefront,
                          title: "Store Profile",
                          onTap: () {
                            _advancedDrawerController.hideDrawer();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const StoreProfileScreen()),
                            );
                          },
                        ),
                        _drawerItem(
                          icon: Icons.support_agent_outlined,
                          title: "Help & Support",
                          onTap: () {
                            _advancedDrawerController.hideDrawer();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HelpAndSupportScreen()),
                            );
                          },
                        ),
                        _drawerItem(
                          icon: Icons.settings_sharp,
                          title: "Settings",
                          onTap: () {
                            _advancedDrawerController.hideDrawer();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SettingScreen()),
                            );
                          },
                        ),
                        _drawerItem(
                          icon: Icons.logout_rounded,
                          title: "Logout",
                          onTap: () async {
                            _advancedDrawerController.hideDrawer();
                            final shouldLogout = await _showLogoutDialog(context);
                            if (shouldLogout == true) {
                              ref.read(homeControllerProvider.notifier).logout();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.white.withOpacity(0.2),
          highlightColor: Colors.white.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showLogoutDialog(BuildContext context) async {
    // Your logout dialog unchanged
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.imageBgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 24),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.error, color: AppColors.imageBgColor, size: 30),
                ),
                const SizedBox(height: 12),
                Text(
                  "Logout",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 26.sp,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Are you sure you want to log out?",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 20.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 22.sp,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () => Navigator.pop(context, false),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

