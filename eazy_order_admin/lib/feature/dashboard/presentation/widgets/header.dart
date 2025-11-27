
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
            "Hi Admin,  Welcome to Eazy Order ",
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

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding / 1.5,
        vertical: defaultPadding / 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        border: Border.all(
            color: AppColors.black,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/profile_pic.png",
            height: 38,
          ),
          if (!Responsive.isMobile(context))
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text("Angelina Jolie"),
            ),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
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
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: AppColors.black),
        ),

        // Border when FOCUSED
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: AppColors.primaryColor,
            width: 2,
          ),
        ),

        // Optional: Padding adjustment
        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      ),
    );

  }
}
