
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteProductDialog extends StatelessWidget {
  const DeleteProductDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Text(
                  'Delete Product',
                  style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black
                  )
              ),
              SizedBox(height: 12.h,),
              Text(
                  'Are you sure you want to delete this product?',
                  style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black.withAlpha(128)
                  )
              ),
              SizedBox(height: 24.h,),
              Container(
                alignment: Alignment.centerRight,
                child: AppButton(
                  text: 'Ok',
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                  },
                  color: AppColors.imageBgColor,
                  width: 80.w,
                  height: 35.h,
                  borderRadius: 12.r,
                  textStyle: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

