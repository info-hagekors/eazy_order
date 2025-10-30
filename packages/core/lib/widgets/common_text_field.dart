
import 'package:core/config/app_colors.dart';
import 'package:core/config/app_consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField({super.key, required this.onChanged,
    this.width, this.hintText, this.hintStyle, this.style,
    this.isObscureText = false, this.obscuringCharacter = '*',
    this.suffixIcon, this.preffixIcon, this.keyboardType, this.inputFormatters,
    this.backgroundColor, this.maxLines = 1, this.controller, this.borderColor,
    this.maxLength, this.enabled = true,});

  final Function(String)? onChanged;
  final double? width;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final bool isObscureText;
  final String obscuringCharacter;
  final Widget? suffixIcon;
  final Widget? preffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Color? backgroundColor;
  final int maxLines;
  final int? maxLength;
  final TextEditingController? controller;
  final Color? borderColor;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConsts.isWeb ? 50 : 50.h,
      width: AppConsts.isWeb ? width ?? 374 : width ?? 374.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConsts.isWeb ? 5 : 5.r),
          border: Border.all(
              color: AppColors.background2
          ),
          color: backgroundColor ?? AppColors.background3
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText ?? '',
          hintStyle: hintStyle ?? GoogleFonts.nunito(
              fontSize: AppConsts.isWeb ? 14 : 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.black.withAlpha(128)
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? AppColors.background3),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? AppColors.borderColor),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: AppConsts.isWeb ? 15 : 15.w,
              vertical: AppConsts.isWeb ? 15 : 15.h),
          suffixIcon: suffixIcon,
          prefixIcon: preffixIcon,
          counterStyle: style,
          counterText: ''
        ),
        style: style ?? GoogleFonts.interTight(
            fontSize: AppConsts.isWeb ? 14 : 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.black
        ),
        maxLines: maxLines,
        onChanged: onChanged,
        obscureText: isObscureText,
        obscuringCharacter: obscuringCharacter,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        enabled: enabled,
      ),
    );
  }
}
