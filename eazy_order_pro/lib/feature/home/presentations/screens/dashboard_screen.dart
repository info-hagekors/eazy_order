import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eazy_order_pro/core/config/app_styles.dart';
import 'package:eazy_order_pro/core/routing/app_router.dart';
import 'package:eazy_order_pro/feature/auth/applications/login_controller.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  static const String routeName = '/dashboard';

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: AppStyles.headerStyle,),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Welcome to Force 360^ App',
              style: AppStyles.headerStyle,
            ),
          ),
          SizedBox(height: 200,),
          InkWell(
            onTap: () {
              //ref.read(goRouterProvider).push(ChangePassword.routeName);
            },
            child: Text(
              'Change Password',
              style: AppStyles.headerStyle,
            ),
          ),
          InkWell(
            onTap: () {
              ref.read(loginControllerProvider.notifier).logout();
            },
            child: Text(
              'Logout',
            ),
          ),
        ],
      ),
    );
  }
}
