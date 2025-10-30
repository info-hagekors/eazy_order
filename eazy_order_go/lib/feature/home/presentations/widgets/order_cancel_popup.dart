import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderCancelPopup extends StatelessWidget {
  const OrderCancelPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        'Cancel Order?',
        style: GoogleFonts.nunito(
            fontSize: 24.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.black
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Are you sure you want to cancel the order?,\nthis action cannot be undone.',
            style: GoogleFonts.nunito(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.black
            ),
          )
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: AppButton(
                text: 'Cancel',
                onPressed: () => Navigator.of(context).pop(),
                color: AppColors.white,
                height: 45.h,
                textStyle: GoogleFonts.nunito(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black
                ),
              ),
            ),
            SizedBox(width: 12.w,),
            Expanded(
              child: AppButton(
                text: 'Ok',
                height: 45.h,
                onPressed: () => Navigator.of(context).pop(true),
                color: AppColors.primaryColor,
                textStyle: GoogleFonts.nunito(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.white
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}


void showCancelOrderDialog(BuildContext context, VoidCallback onConfirm) {
  showDialog(
    context: context,
    barrierDismissible: false, // User must confirm/cancel
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Cancel Order'),
        content: Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              onConfirm(); // Proceed with cancellation
            },
            child: Text('Yes, Cancel'),
          ),
        ],
      );
    },
  );
}
