import 'package:core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'Contact Details',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),

            SizedBox(height: 6.h),
            Divider(color: AppColors.grey300),
            SizedBox(height: 12.h),

            Text(
              'Name :',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6.h),
            _inputField(
                hint: 'Enter name',
              controller: nameController
            ),
            SizedBox(height: 14.h),

            Text(
              'Mobile Number :',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6.h),
            _inputField(
              hint: 'Enter mobile number',
              keyboardType: TextInputType.phone,
              controller: mobileController,
            ),

            SizedBox(height: 30.h),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'name': nameController.text.trim(),
                    'mobile': mobileController.text.trim(),
                  });

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: 80.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        suffixStyle: TextStyle(fontSize: 10),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 12.h,
        ),
        filled: true,
        fillColor: AppColors.grey100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: AppColors.primaryColor,
            width: 1.2,
          ),
        ),
      ),
    );
  }
}

