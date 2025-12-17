
import 'package:core/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showLoadingDialog(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Loading...',
    barrierColor: Colors.black.withAlpha(89),
    pageBuilder: (ctx, a1, a2) => _LoadingFullScreen(),
    transitionDuration: const Duration(milliseconds: 150),
    transitionBuilder: (ctx, anim, _, child) => FadeTransition(opacity: anim, child: child),
    useRootNavigator: true,
  );
}

void hideLoadingDialog(BuildContext context) {
  if (Navigator.of(context, rootNavigator: true).canPop()) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

class _LoadingFullScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.transparent,
      content: Container(
        height: 150,
        width: 200,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(140),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8.h),
            CircularProgressIndicator(strokeWidth: 3, color: AppColors.white,),
            SizedBox(height: 24.h),
            Flexible(
              child: Text(
                'Loading...',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}