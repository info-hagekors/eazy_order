import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class OrderStatusOverlay extends StatefulWidget {
  final bool isSuccess;
  final String message;

  const OrderStatusOverlay({
    super.key,
    required this.isSuccess,
    required this.message,
  });

  @override
  State<OrderStatusOverlay> createState() => _OrderStatusOverlayState();
}

class _OrderStatusOverlayState extends State<OrderStatusOverlay> {

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2)).then((val) {
      Navigator.of(context).pop();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final animation = widget.isSuccess
        ? AppImages.animOrderSuccess
        : AppImages.animOrderFail;

    return Scaffold(
      backgroundColor: AppColors.black.withAlpha(154),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withAlpha(51),
                blurRadius: 12,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(animation, height: 120),
              const SizedBox(height: 16),
              Text(
                widget.isSuccess ? 'Yippee!' : 'Oops!',
                style: GoogleFonts.nunito(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: widget.isSuccess ? AppColors.green : AppColors.red,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
