
import 'package:core/core.dart';
import 'package:eazy_order_go/feature/auth/applications/login_controller.dart';
import 'package:eazy_order_go/feature/auth/presentation/widgets/verify_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  TextEditingController pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);
    //pinController.text = state.pin;
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            CustomPaint(
              size: Size(double.infinity, double.infinity),
              painter: CurvedBackground(),
            ),
            CustomPaint(
              size: Size(double.infinity, double.infinity),
              painter: CurvedBackgroundBottom(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter Mobile number to continue',
                    style: GoogleFonts.nunito(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  CommonTextField(
                    onChanged: ref.read(loginControllerProvider.notifier).onMobileChanged,
                    hintText: 'Mobile Number',
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 24.h),
                  AppButton(
                    text: 'Login',
                    textStyle: GoogleFonts.nunito(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white
                    ),
                    color: AppColors.primaryColor,
                    isLoading: state.isLoading,
                    onPressed: state.isValid ? () async {
                      FocusScope.of(context).unfocus();
                      final result = await ref.read(loginControllerProvider.notifier).onSendOtp();
                      if (result) {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            isDismissible: false,
                            builder: (context) {
                              return SizedBox(
                                  height: 732.h,
                                  width: 429.w,
                                  child: VerifyDialog(mobile: state.mobile, countryCode: '+91',)
                              );
                            }
                        ).then((val) {
                          if (val ?? false) {
                            ref.read(loginControllerProvider.notifier).getBusinessByMobile('91${state.mobile}');
                          }
                        });
                      }
                    } : null,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurvedBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.accentColor;

    final path = Path();
    path.lineTo(0, size.height * 0.15);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.25, size.width, size.height * 0.1);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CurvedBackgroundBottom extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.accentColor;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.85);
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.75, size.width, size.height * 0.9,
    );
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


