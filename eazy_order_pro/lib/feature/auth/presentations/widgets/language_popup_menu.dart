/*

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguagePopupMenu extends ConsumerWidget {
  const LanguagePopupMenu({super.key, required this.onSelected});

  final Function(bool) onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageState = ref.watch(languagePickerControllerProvider);
    final languageController = ref.read(languagePickerControllerProvider.notifier);
    return PopupMenuButton<LanguageModel>(
      onSelected: (val) {
        languageController.onSelectLanguage(val, onSelected: () {
          languageController.onLanguageSave();
          onSelected.call(false);
        });
      },
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      offset: Offset(10, 50.h),
      menuPadding: EdgeInsets.only(top: 8.h, bottom: 8.h),
      color: AppColors.white,
      borderRadius: BorderRadius.circular(8.r),
      constraints: BoxConstraints(
        minWidth: 149.w, // Minimum width of the popup
        maxWidth: 149.w, // Maximum width of the popup
      ),
      onOpened: () => onSelected.call(true),
      onCanceled: () => onSelected.call(false),
      itemBuilder: (context) {
        return languageState.languageList.map((e) => PopupMenuItem(
          value: e,
          height: 30.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
          child: _commonLanguage(e.squareIcon, e.name, isSelected: languageState.selectedLanguage.name == e.name),
        )).toList();
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 95.w, maxWidth: 100.w),
        child: Container(
          height: 30.h,
          decoration: BoxDecoration(
              color: AppColors.backgroundGray,
              borderRadius: BorderRadius.circular(8.r)
          ),
          child: SizedBox(
            width: 100.w,
            child: Row(
              children: [
                SizedBox(width: 6.w,),
                SvgPicture.asset(languageState.selectedLanguage.squareIcon, height: 16.h, width: 16.w,),
                SizedBox(width: 10.w,),
                Text(
                  languageState.selectedLanguage.name,
                  style: GoogleFonts.interTight(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black
                  ),
                ),
                SizedBox(width: 5.w,),
                Icon(Icons.keyboard_arrow_down, size: 10.w,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _commonLanguage(String icon, String text, {bool isSelected = false, bool isArrowDisplayed = false}) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 133.w, maxWidth: 133.w),
      child: Container(
        height: 30.h,
        width: double.infinity,
        decoration: BoxDecoration(
            color: isSelected ? AppColors.backgroundGray : null,
            borderRadius: BorderRadius.circular(8.r)
        ),
        child: SizedBox(
          width: 133.w,
          child: Row(
            children: [
              SizedBox(width: 6.w,),
              SvgPicture.asset(icon),
              SizedBox(width: 10.w,),
              Text(
                text,
                style: GoogleFonts.interTight(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black
                ),
              ),
              if (isArrowDisplayed) ... [
                SizedBox(width: 6.w,),
                Icon(Icons.keyboard_arrow_down, size: 10.h,)
              ],
            ],
          ),
        ),
      ),
    );
  }
}
*/
