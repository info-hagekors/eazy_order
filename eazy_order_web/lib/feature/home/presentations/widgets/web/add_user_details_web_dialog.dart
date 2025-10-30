
import 'package:core/core.dart';
import 'package:eazy_order_web/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddUserDetailsWebDialog extends ConsumerStatefulWidget {
  const AddUserDetailsWebDialog({super.key,});

  @override
  ConsumerState<AddUserDetailsWebDialog> createState() => _AddUserDetailsWebDialogState();
}

class _AddUserDetailsWebDialogState extends ConsumerState<AddUserDetailsWebDialog> {

  late final TextEditingController _mobileController = TextEditingController();
  late final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            Text(
              'Please provide your details',
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.black
              )
            ),
            SizedBox(height: 24,),
            CommonTextField(
              controller: _mobileController,
              onChanged: (val) {},
              hintText: 'Mobile Number',
            ),
            SizedBox(height: 12,),
            CommonTextField(
              controller: _nameController,
              onChanged: (val) {},
              hintText: 'User Name',
            ),
            SizedBox(height: 24),
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
                color: AppColors.primaryButtonColor,
                width: 100,
                height: 35,
                borderRadius: 24,
                textStyle: GoogleFonts.nunito(
                    fontSize: 15,
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
