
import 'package:core/core.dart';
import 'package:core/utils/toast_utils.dart';
import 'package:eazy_order_admin/feature/catalog/presentation/screens/category_screen.dart';
import 'package:eazy_order_admin/feature/catalog/presentation/screens/product_screen.dart';
import 'package:eazy_order_admin/feature/dashboard/application/menu_app_controller.dart';
import 'package:eazy_order_admin/feature/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:eazy_order_admin/feature/dashboard/presentation/widgets/side_menu.dart';
import 'package:eazy_order_admin/feature/main_screen/applications/main_screen_controller.dart';
import 'package:eazy_order_admin/feature/order/presentations/screens/orderscreen.dart';
import 'package:eazy_order_admin/feature/profile/presentations/screen/profile_drawer.dart';
import 'package:eazy_order_admin/feature/user/presentations/screens/user_screen.dart';
import 'package:eazy_order_admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, required this.businessId});

  static const String routeName = '/main_screen';

  final String businessId;

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  Widget selectedScreen = DashboardScreen();

  @override
  void initState() {
    ref.read(mainScreenControllerProvider.notifier).setBusinessId(widget.businessId);
    ref.read(mainScreenControllerProvider.notifier).getBusinessDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      key: MenuAppController.scaffoldKey,
      backgroundColor: AppColors.background3,
      endDrawer: const ProfileDrawer(),
      // Drawer appears ONLY on small screens
      drawer: isDesktop ? null : SideMenu(onItemClick: onMenuClick),

      body: SafeArea(
        child: Row(
          children: [
            // Permanent menu on desktop
            if (isDesktop)
              Expanded(
                child: SideMenu(onItemClick: onMenuClick),
              ),

            Expanded(
              flex: 5,
              child: selectedScreen,
            ),
          ],
        ),
      ),
    );
  }

  void onMenuClick(int selectedIndex) {
    print('Selected index >>>> $selectedIndex');
    switch(selectedIndex) {
      case 1:
        selectedScreen = DashboardScreen();
        break;
      case 2:
        selectedScreen = UserScreen();     //for user screen
        break;
      case 3:
        selectedScreen = CategoryScreen(businessId: widget.businessId);    // for catalog screen
        break;
      case 4:
        selectedScreen = ProductScreen(businessId: widget.businessId);   //for product screen
        break;
      case 5:
        selectedScreen = OrderScreen();   //for order screen
        break;
      case 6:
        selectedScreen = DashboardScreen();   //for customer screen
        break;

      default:
        selectedScreen = Container();
        break;
    }
    setState(() { });
  }
}
