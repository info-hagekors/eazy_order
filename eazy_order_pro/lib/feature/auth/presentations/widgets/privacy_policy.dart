/*

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:core/core.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  static const privacyPolicy = "Your privacy is important to us. It is Jiinue's policy to respect your privacy and comply with any applicable law and regulation regarding any personal information we may collect about you, including via our app, Jiinue, and its associated services.\n\nPersonal information is any information about you which can be used to identify you. This includes information about you as a person (such as name, address, and date of birth), your devices, payment details, and even information about how you use an app or online service.\n\nIn the event our app contains links to third-party sites and services, please be aware that those sites and services have their own privacy policies. After following a link to any third-party content, you should read their posted privacy policy information about how they collect and use personal information. This Privacy Policy does not apply to any of your activities after you leave our app.";
  static const infoWeCollect = "Information we collect falls into one of two categories: “voluntarily provided” information and “automatically collected” information.\n\n“Voluntarily provided” information refers to any information you knowingly and actively provide us when using our app and its associated services.\n\n“Automatically collected” information refers to any information automatically sent by your device in the course of accessing our app and its associated services.";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 30.w, right: 30.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.42.h,),
            Text(
              'Privacy Policy',
              style: GoogleFonts.interTight(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.label1
              ),
            ),
            SizedBox(height: 20.h,),
            Text(
              privacyPolicy,
              style: GoogleFonts.interTight(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w300,
                  color: AppColors.black.withAlpha(178)
              ),
            ),
            SizedBox(height: 46.h,),
            Text(
              'Information we collect\n',
              style: GoogleFonts.interTight(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.label1
              ),
            ),
            Text(
              infoWeCollect,
              style: GoogleFonts.interTight(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w300,
                  color: AppColors.black.withAlpha(178)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
