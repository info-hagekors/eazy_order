
import 'package:core/config/app_colors.dart';
import 'package:core/config/app_consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppButton extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? color;
  final Color? disabledColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final Widget? child;
  final Color? borderColor;

  const AppButton({super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.color,
    this.disabledColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.textStyle,
    this.child,
    this.borderColor
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? (AppConsts.isWeb ? 58 : 58.h),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.blue, // Default color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius.r),
            side:  BorderSide(
              color: borderColor ?? AppColors.transparent,
            )
          ),
          disabledBackgroundColor: disabledColor ?? Colors.grey
        ),
        child: isLoading
            ? SizedBox(
          width: AppConsts.isWeb ? 24 : 24.w,
          height: AppConsts.isWeb ? 24 : 24.h,
          child: CircularProgressIndicator(
            strokeWidth: AppConsts.isWeb ? 2.5 : 2.5.r,
            color: Colors.white,
          ),
        )
            : child ?? Text(
          text,
          style: textStyle ?? GoogleFonts.poppins(
            color: textColor ?? AppColors.white,
            fontSize: AppConsts.isWeb ? 16 : 16.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
