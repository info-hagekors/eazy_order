/*

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiinue/feature/auth/applications/agree_and_continue_controller.dart';
import 'package:jiinue/core/config/app_colors.dart' as colors;

class AgreeAndContinue extends ConsumerWidget {
  const AgreeAndContinue({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(agreeAndContinueControllerProvider.notifier);
    final state = ref.watch(agreeAndContinueControllerProvider);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 26.5.w, right: 22.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.42.h,),
                  Text(
                    'Agree and Continue',
                    style: GoogleFonts.interTight(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black
                    ),
                  ),
                  SizedBox(height: 24.h,),
                  Text(
                    'We need some permission',
                    style: GoogleFonts.interTight(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.label1
                    ),
                  ),
                  SizedBox(height: 24.h,),
                  Text(
                    "It’s important that you understand what information Jiinue collects, uses and how you can control it. We explain in detail in our updated Jiinue Privacy Policy and you can review the key points below.\n\nWhy does Jiinue use your data? To give you a customised Jiinue experience, improve our services, understand how users use Jiinue, and more.",
                    style: GoogleFonts.interTight(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.label1.withAlpha(178)
                    ),
                  ),
                  SizedBox(height: 40.h,),
                  Text(
                    'Information Collected',
                    style: GoogleFonts.interTight(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.label1
                    ),
                  ),
                  SizedBox(height: 16.h,),
                  ExpansionPanelList(
                    elevation: 0,
                    dividerColor: AppColors.transparent,
                    expandedHeaderPadding: EdgeInsets.zero,
                    materialGapSize: 0,
                    expansionCallback: (index, isExpanded) {
                      controller.onInfoOpened(state.infoList[index].title, isExpanded);
                    },
                    children: state.infoList.map((info) {
                      return _commonExpanded(info.icon, info.title, info.desc, controller, info.isOpened);
                    }).toList(),
                  ),
                  SizedBox(height: 8.h,),
                  CustomisedInkwell(
                    onTap: () => controller.onTapAgree(!state.isAgree),
                    child: Row(
                      children: [
                        SvgPicture.asset(state.isAgree ? AppImages.icCheckOn : AppImages.icCheckOff, height: 25.h, width: 25.w,),
                        SizedBox(width: 14.w,),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'By signing up you agree to our ',
                                    style: GoogleFonts.interTight(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.label2
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Terms of Use',
                                    style: GoogleFonts.interTight(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.label2
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = controller.onTapTermsOfUse,
                                  ),
                                  TextSpan(
                                    text: ' and ',
                                    style: GoogleFonts.interTight(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.label2
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: GoogleFonts.interTight(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.label2
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = controller.onTapPrivacyPolicy,
                                  )
                                ]
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h,),
                  AppButton(
                    text: 'Agree And Continue',
                    color: state.isAgree ? colors.AppColors.primaryColor : AppColors.disabledTextColor,
                    textColor: state.isAgree ? AppColors.white : AppColors.disabledTextColor,
                    disabledColor: AppColors.disabledButtonColor,
                    onPressed: state.isAgree ? () {
                      controller.onAgreeAndContinue();
                    } : null,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 40.h,),
      ],
    );
  }

  ExpansionPanel _commonExpanded(String icon, String title, String description, controller, bool isOpened) {
    return ExpansionPanel(
      backgroundColor: AppColors.white,
      canTapOnHeader: true,
      splashColor: AppColors.transparent,
      highlightColor: AppColors.white,
      headerBuilder: (context, val) {
        return Row(
          children: [
            SvgPicture.asset(icon, height: 24.h, width: 24.w,),
            SizedBox(width: 8.w,),
            Text(
              title,
              style: GoogleFonts.interTight(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.label1
              ),
            ),
          ],
        );
      },
      isExpanded: isOpened,
      body: Padding(
        padding: EdgeInsets.only(left: 33.w, right: 36.w),
        child: Text(
          description,
          style: GoogleFonts.interTight(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.black.withAlpha(178)
          ),
        ),
      ),
      //tilePadding: EdgeInsets.zero,
      //childrenPadding: EdgeInsets.zero,
      //minTileHeight: 44.h,
      //initiallyExpanded: isOpened,
      //shape: Border(),
    );
  }
}
*/
