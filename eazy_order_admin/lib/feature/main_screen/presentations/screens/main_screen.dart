
import 'package:core/utils/toast_utils.dart';
import 'package:eazy_order_admin/feature/dashboard/application/menu_app_controller.dart';
import 'package:eazy_order_admin/feature/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:eazy_order_admin/feature/dashboard/presentation/widgets/side_menu.dart';
import 'package:eazy_order_admin/feature/main_screen/applications/main_screen_controller.dart';
import 'package:eazy_order_admin/feature/user/presentations/screens/user_screen.dart';
import 'package:eazy_order_admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:provider/provider.dart';


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
    return Scaffold(
      key: MenuAppController.scaffoldKey,
      drawer: SideMenu(onItemClick: (index) => onMenuClick(index),),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(onItemClick: (index) => onMenuClick(index),),
              ),
            Expanded(
              // It takes 5/6 part of the screen
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
        selectedScreen = UserScreen();
        break;
      case 3:
        selectedScreen = DashboardScreen();
      case 4:
        selectedScreen = DashboardScreen();
        break;
      default:
        selectedScreen = Container();
        break;
    }
    setState(() { });
  }
}
