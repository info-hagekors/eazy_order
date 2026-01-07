import 'package:core/config/app_colors.dart';
import 'package:core/widgets/app_button.dart';
import 'package:core/widgets/common_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactDialog extends StatefulWidget {
  const ContactDialog({super.key});

  @override
  State<ContactDialog> createState() => _ContactDialogState();
}

class _ContactDialogState extends State<ContactDialog> {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Details :',
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),

            SizedBox(height: 6.h),
            Divider(color: AppColors.grey300),
            SizedBox(height: 18.h),

            _label('Name '),
            SizedBox(height: 6.h),
            CommonTextField(
              hintText: 'Enter name...',
              controller: nameController,
              preffixIcon: Icon(Icons.person),
              onChanged: (String p1) {},
            ),
            SizedBox(height: 20.h),

            _label('Mobile Number '),
            SizedBox(height: 6.h),
            CommonTextField(
              hintText: 'Enter mobile number...',
              preffixIcon: Icon(Icons.phone),
              keyboardType: TextInputType.phone,
              controller: mobileController,
              maxLength: 10,
              onChanged: (String p1) {},
            ),
            SizedBox(height: 30.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "cancel",
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                AppButton(
                  height: 45.h,
                  width: 120.w,
                  color: AppColors.primaryColor,
                  onPressed: () {
                    Navigator.pop(context, {
                      'name': nameController.text.trim(),
                      'mobile': mobileController.text.trim(),
                    });
                  },
                  text: 'Save',
                  borderRadius: 28.r,
                  textStyle: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      '$text :',
      style: GoogleFonts.poppins(
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.grey600,
      ),
    );
  }
}
