import 'package:core/config/app_colors.dart';
import 'package:core/config/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool showLeading;
  final Widget? leading;
  final List<Widget> actions;
  final Color backgroundColor;
  final TextStyle? titleStyle;
  final bool centerTitle;
  final double? leadingWidth;

  const CommonAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.showLeading = true,
    this.leading,
    this.actions = const [],
    this.backgroundColor = AppColors.white,
    this.titleStyle,
    this.centerTitle = false,
    this.leadingWidth,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      title: Text(
        title,
        style: titleStyle ?? GoogleFonts.interTight(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),
      ),
      leading: showLeading ? leading ?? _defaultBackArrow(context) : null,
      leadingWidth: leadingWidth,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  Widget _defaultBackArrow(BuildContext context) {
    return IconButton(
      onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      icon: SvgPicture.asset(
        AppImages.icArrowBack,
        width: 24.w,
        height: 24.h,
      ),
    );
  }
}
