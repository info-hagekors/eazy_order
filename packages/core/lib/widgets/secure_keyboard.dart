
import 'dart:math';

import 'package:core/config/app_colors.dart';
import 'package:core/config/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SecureKeyboard extends StatelessWidget {
  const SecureKeyboard({super.key, required this.onKeyTap, this.isRandom = false});

  final Function(String, bool, bool) onKeyTap;
  final bool isRandom;

  @override
  Widget build(BuildContext context) {
    return buildSecureKeyboard();
  }

  Widget buildSecureKeyboard() {
    List<String> digits = List.generate(10, (index) => index.toString());
    if (isRandom) {
      digits.shuffle(Random()); // Shuffle the digits randomly
    }

    List<List<String>> keyboardLayout = [
      digits.sublist(1, 4),
      digits.sublist(4, 7),
      digits.sublist(7, 10),
      ['back', digits[0], 'enter'], // Keep back and enter in the last row
    ];
    return Column(
      children: [
        for (var row in keyboardLayout) ... [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((key) => buildKeyButton(key)).toList(),
          ),
          SizedBox(height: 10.w,)
        ]
      ],
    );
  }

  Widget buildKeyButton(String key) {
    return Padding(
      padding: EdgeInsets.only(right: 15.w),
      child: GestureDetector(
        onTap: () => onKeyTap(key, key == 'back', key == 'enter'),
        child: Container(
          width: 112.w,
          height: 54.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
              border: Border.all(
                  color: AppColors.disabledButtonColor
              )
          ),
          child: key == 'back' ? SvgPicture.asset(AppImages.icClearField, height: 24.h, width: 24.w,)
              : key == 'enter' ? SvgPicture.asset(AppImages.icEnter, height: 24.h, width: 24.w,) : Text(
            key == "back" ? "⌫" : key.toUpperCase(),
            style: GoogleFonts.interTight(
                fontSize: 20.sp, color: Colors.black,
                fontWeight:  FontWeight.w600
            ),
          ),
        ),
      ),
    );
  }
}
