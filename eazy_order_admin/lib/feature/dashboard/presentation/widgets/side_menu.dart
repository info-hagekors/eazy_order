import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    super.key,
    required this.onItemClick,
  });

  final Function(int) onItemClick;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.primaryColor,
      elevation: 10,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              border: Border(bottom: Divider.createBorderSide(context, color: AppColors.white)),
            ),
            child: Image.asset("assets/images/app_logo_trans.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () => onItemClick(1),
          ),
          DrawerListTile(
            title: "Users",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () => onItemClick(2),
          ),
          DrawerListTile(
            title: "Orders",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () => onItemClick(3),
          ),
          DrawerListTile(
            title: "Customers",
            svgSrc: "assets/icons/menu_store.svg",
            press: () => onItemClick(4),
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  });

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 10,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: AppColors.white),
      ),
    );
  }
}
