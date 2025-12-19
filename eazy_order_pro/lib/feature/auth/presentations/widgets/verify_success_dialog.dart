
import 'package:eazy_order_pro/core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifySuccessDialog extends StatefulWidget {
  const VerifySuccessDialog({super.key, required this.title, this.subTitle = '', required this.icon});

  final String title;
  final String subTitle;
  final String icon;

  @override
  State<VerifySuccessDialog> createState() => _VerifySuccessDialogState();
}

class _VerifySuccessDialogState extends State<VerifySuccessDialog> {

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then((val) {
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.zero,
      content: Container(
        height: 217.h,
        width: 355.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: AppColors.white
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50.h,
              width: 50.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: AppColors.primaryColor,
              ),
              child: SvgPicture.asset(widget.icon, height: 30.h, width: 30.w, colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),),
            ),
            SizedBox(height: 15.h,),
            Text(
              widget.title,
              style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.label1
              ),
            ),
            SizedBox(height: 16.h,),
            Text(
              widget.subTitle,
              style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w300,
                  color: AppColors.black
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 36.h,),
          ],
        ),
      ),
    );
  }
}
