
import 'package:core/core.dart';
import 'package:eazy_order_admin/constants.dart';
import 'package:eazy_order_admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../application/menu_app_controller.dart';
//import 'package:provider/provider.dart';


class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: Icon(Icons.menu),
            color: AppColors.black,
            onPressed: () {
              MenuAppController.scaffoldKey.currentState?.openDrawer();
            },
          ),
        SizedBox(width: 7),
        if (!Responsive.isMobile(context))
          Text(
            "Hi ,  Welcome to Eazy Order ",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,color: AppColors.primaryColor
            ),
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        Expanded(child: SearchField()),
        ProfileCard()
      ],
    );
  }
}
class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
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

        // Border when NOT focused
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
              color: AppColors.black12
          ),
        ),

        // Border when FOCUSED
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: AppColors.black,
            width: 1,
          ),
        ),
        // Optional: Padding adjustment
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      ),
    );
  }
}
class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.zero,
      color: AppColors.white,
      tooltip: '',
      offset: const Offset(0, 50),
      onSelected: (value) {
        if (value == 0) {
          MenuAppController.scaffoldKey.currentState?.openEndDrawer();
          debugPrint("Profile clicked");
        } else if (value == 1) {
          // 👉 Logout logic
          debugPrint("Logout clicked");
        }
      },
      itemBuilder: (context) =>  [
        PopupMenuItem<int>(
          value: 0,
          child: SizedBox(
            width: 150,
            child: Row(
              children: [
                Icon(Icons.person_outline, size: 20,color: AppColors.black,),
                SizedBox(width: 20),
                Text("Profile",style: TextStyle(color: AppColors.black)),
              ],
            ),
          ),
        ),
        PopupMenuItem<int>(
          value: 1,
          child: SizedBox(
            width: 150,
            child: Row(
              children: [
                Icon(Icons.logout, size: 20, color: AppColors.red),
                SizedBox(width: 20),
                Text(
                  "Logout",
                  style: TextStyle(color: AppColors.red),
                ),
              ],
            ),
          ),
        ),
      ],
      child: Container(
        margin: EdgeInsets.only(left: defaultPadding),
        padding: EdgeInsets.symmetric(
          horizontal: defaultPadding / 1.5,
          vertical: defaultPadding / 4,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(
              color: AppColors.black12,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.white,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.black45,
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  "assets/images/profile_pic.png",
                  height: 38,
                ),
              ),
            ),
            if (!Responsive.isMobile(context))
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                child: SizedBox(
                  width: 110,
                  child: Text("Angelina Jolie",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: AppColors.black),),
                ),
              ),
            Icon(Icons.keyboard_arrow_down, color: AppColors.black,),
          ],
        ),
      ),
    );
  }
}