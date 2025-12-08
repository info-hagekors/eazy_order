
import 'package:core/core.dart';
import 'package:eazy_order_go/feature/home/applications/qr_code_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeScreen extends ConsumerStatefulWidget {
  const QrCodeScreen({super.key});

  static const String routeName = '/qr_code';

  @override
  ConsumerState<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends ConsumerState<QrCodeScreen> {

  final GlobalKey _qrKey = GlobalKey();

  @override
  void initState() {
    ref.read(qrCodeControllerProvider.notifier).getBusinessData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(qrCodeControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.screenBgColor,
      appBar: CommonAppBar(
        title: '',
        backgroundColor: AppColors.screenBgColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            if (state.businessModel?.businessId.isNotEmpty ?? false) ... [
              Container(
                alignment: Alignment.center,
                child: RepaintBoundary(
                  key: _qrKey,
                  child: QrImageView(
                    data: '${AppConsts.webAppUrl}${state.businessModel?.businessId ?? ''}',
                    version: QrVersions.auto,
                    size: 300.h,
                    embeddedImage: (state.businessModel?.logo.isNotEmpty ?? false)
                        ? NetworkImage(state.businessModel?.logo ?? '') : null,
                    embeddedImageStyle: QrEmbeddedImageStyle(size: Size(60, 60)),
                  ),
                ),
              ),
            ] else ... [
              Container(
                height: 300.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.black
                  ),
                  borderRadius: BorderRadius.circular(10.r)
                ),
                padding: EdgeInsets.all(20.w),
                child: Text(
                  'QR Code is not generated, Please contact support',
                  style: GoogleFonts.interTight(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            SizedBox(height: 32.h,),
            Text(
              state.businessModel?.name ?? '',
              style: GoogleFonts.roboto(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h,),
            if (state.businessModel?.businessId.isNotEmpty ?? false) ... [
              AppButton(
                text: 'Share',
                onPressed: () {
                  ref.read(qrCodeControllerProvider.notifier).shareQrCode(_qrKey);
                },
                width: 120.w,
                height: 45.h,
                borderRadius: 32.r,
                textColor: AppColors.primaryColor,
                borderColor: AppColors.primaryColor,
                color: AppColors.imageBgColor,
              ),
            ],
            Spacer(),
            Spacer(),
            SizedBox(height: 32.h,),
            Text(
              '© 2025 Eazy Order ❤️ by Hagekors Technolabs',
              style: GoogleFonts.robotoMono(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: AppConsts.bottomPadding,)
          ],
        ),
      ),
    );
  }
}
