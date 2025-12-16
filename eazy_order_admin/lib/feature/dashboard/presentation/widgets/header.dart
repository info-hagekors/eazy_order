import 'package:core/core.dart';
import 'package:eazy_order_admin/constants.dart';
import 'package:eazy_order_admin/feature/profile/applications/profile_controller.dart';
import 'package:eazy_order_admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../application/menu_app_controller.dart';


class AppHeader extends ConsumerWidget {
  const AppHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);

    return Row(
      children: [
        /// ☰ Menu icon (Mobile / Tablet)
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            color: AppColors.black,
            onPressed: () {
              MenuAppController.scaffoldKey.currentState?.openDrawer();
            },
          ),

        const SizedBox(width: 8),

        /// 👋 Welcome Text
        if (!Responsive.isMobile(context))
          Text(
            "Hi,   Welcome to Eazy Order",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
              fontSize: 18
            ),
          ),

        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),

        /// 🔍 Search Field
        Expanded(
          child: TextField(
            cursorColor: AppColors.primaryColor,
            decoration: InputDecoration(
              hintText: "    Search",
              hintStyle: TextStyle(color: Colors.grey.shade600),
              filled: true,
              fillColor: AppColors.white,
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Icon(Icons.search, color: Colors.grey),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.black12),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.black, width: 1),
              ),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            ),
          ),
        ),

        /// 👤 Profile Popup
        PopupMenuButton<int>(
          padding: EdgeInsets.zero,
          color: AppColors.white,
          tooltip: '',
          offset: const Offset(0, 50),
          onSelected: (value) {
            if (value == 0) {
              MenuAppController.scaffoldKey.currentState?.openEndDrawer();
            } else if (value == 1) {
              Fluttertoast.showToast(msg: "Logout clicked");
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem<int>(
              value: 0,
              child: SizedBox(
                width: 150,
                child: Row(
                  children: const [
                    Icon(Icons.person_outline, size: 20,color: AppColors.black,),
                    SizedBox(width: 20),
                    Text("Profile",style: TextStyle(color: AppColors.black),),
                  ],
                ),
              ),
            ),
            PopupMenuItem<int>(
              value: 1,
              child: SizedBox(
                width: 150,
                child: Row(
                  children: const [
                    Icon(Icons.logout, size: 20, color: AppColors.red),
                    SizedBox(width: 20),
                    Text("Logout", style: TextStyle(color: AppColors.red)),
                  ],
                ),
              ),
            ),
          ],
          child: Container(
            height: 49,
            margin: const EdgeInsets.only(left: defaultPadding),
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding / 1.5,
              vertical: defaultPadding / 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: AppColors.black12,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.white,
                  blurRadius: 4,
                  offset: Offset(0,2),
                )
              ]
            ),
            child: Row(
              children: [
                /// Avatar
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.black45,
                    width: 1
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset("assets/images/placeholder.png",
                      height: 28,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                if (!Responsive.isMobile(context))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                    child: SizedBox(
                      width: 150,
                      child: Text(
                        profile.username.isEmpty
                            ? "User"
                            : profile.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: AppColors.black),
                      ),
                    ),
                  ),
                const Icon(Icons.keyboard_arrow_down, color: AppColors.black),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
