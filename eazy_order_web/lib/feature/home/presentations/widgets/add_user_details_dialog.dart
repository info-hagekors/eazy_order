
import 'package:core/core.dart';
import 'package:eazy_order_web/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddUserDetailsDialog extends ConsumerStatefulWidget {
  const AddUserDetailsDialog({super.key,});

  @override
  ConsumerState<AddUserDetailsDialog> createState() => _AddUserDetailsDialogState();
}

class _AddUserDetailsDialogState extends ConsumerState<AddUserDetailsDialog> {

  late final TextEditingController _mobileController = TextEditingController();
  late final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.imageBgColor,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),
            Text(
              'Please provide your details',
              style: GoogleFonts.roboto(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor
              )
            ),
            SizedBox(height: 24.h,),
            CommonTextField(
              controller: _mobileController,
              onChanged: (val) {},
              hintText: 'Mobile Number',
            ),
            SizedBox(height: 12.h,),
            CommonTextField(
              controller: _nameController,
              onChanged: (val) {},
              hintText: 'User Name',
            ),
            SizedBox(height: 24.h),
            Container(
              alignment: Alignment.centerRight,
              child: AppButton(
                text: 'OK',
                onPressed: () async {
                  if (_mobileController.text.trim().isEmpty) {
                    Fluttertoast.showToast(msg: 'Please enter mobile number to continue');
                    return;
                  }
                  if (_nameController.text.trim().isEmpty) {
                    Fluttertoast.showToast(msg: 'It would be great if you provide your name');
                    return;
                  }
                  ref.read(goRouterProvider).pop({'mobile':_mobileController.text.trim(), 'name':_nameController.text.trim()});
                },
                color: AppColors.primaryColor,
                width: 110.w,
                height: 40.h,
                borderRadius: 24.r,
                textStyle: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white
                ),
              ),
            ),
            //SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
