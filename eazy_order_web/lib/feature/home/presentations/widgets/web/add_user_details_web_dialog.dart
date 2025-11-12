import 'package:core/core.dart';
import 'package:eazy_order_web/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddUserDetailsWebDialog extends ConsumerStatefulWidget {
  const AddUserDetailsWebDialog({super.key});

  @override
  ConsumerState<AddUserDetailsWebDialog> createState() =>
      _AddUserDetailsWebDialogState();
}

class _AddUserDetailsWebDialogState
    extends ConsumerState<AddUserDetailsWebDialog> {
  late final TextEditingController _mobileController = TextEditingController();
  late final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 23),
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.bgColor2.withOpacity(0.9),
              AppColors.imageBgColor.withOpacity(0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Please provide your details',
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 📱 Mobile number field with 10-digit limit
              CommonTextField(
                controller: _mobileController,
                onChanged: (val) {
                  if (val.length > 10) {
                    _mobileController.text = val.substring(0, 10);
                    _mobileController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _mobileController.text.length),
                    );
                    Fluttertoast.showToast(
                      msg: 'Mobile number cannot exceed 10 digits',
                    );
                  }
                },
                hintText: 'Mobile Number',
                keyboardType: TextInputType.number,
                maxLength: 10, // ✅ Ensures only 10 digits can be typed
              ),

              const SizedBox(height: 12),

              // 👤 User name field
              CommonTextField(
                controller: _nameController,
                onChanged: (val) {},
                hintText: 'User Name',
              ),

              const SizedBox(height: 24),

              // ✅ Submit button
              Align(
                alignment: Alignment.centerRight,
                child: AppButton(
                  text: 'OK',
                  onPressed: () async {
                    final mobile = _mobileController.text.trim();
                    final name = _nameController.text.trim();

                    // 🧩 Validation
                    if (mobile.isEmpty) {
                      Fluttertoast.showToast(
                          msg: 'Please enter mobile number to continue');
                      return;
                    }
                    if (mobile.length != 10) {
                      Fluttertoast.showToast(
                          msg: 'Mobile number must be exactly 10 digits');
                      return;
                    }
                    if (name.isEmpty) {
                      Fluttertoast.showToast(
                          msg: 'It would be great if you provide your name');
                      return;
                    }

                    // ✅ All good — close dialog with data
                    ref.read(goRouterProvider).pop({
                      'mobile': mobile,
                      'name': name,
                    });
                  },
                  color: AppColors.primaryColor,
                  width: 100,
                  height: 35,
                  borderRadius: 24,
                  textStyle: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
