import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QRNotFoundScreen extends StatefulWidget {
  const QRNotFoundScreen({super.key});

  static const String routeName = '/qr_scan';

  @override
  State<QRNotFoundScreen> createState() => _QRNotFoundScreenState();
}

class _QRNotFoundScreenState extends State<QRNotFoundScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppConsts.isWeb ? _webUI() : _commonUI();
  }

  Widget _webUI() {
    return Container(
      alignment: Alignment.center,
      color: Colors.grey.shade50,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: AppConsts.webAppWidth),
        child: _commonUI(),
      ),
    );
  }

  Widget _commonUI() {
    return Scaffold(
      backgroundColor: AppColors.imageBgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.invalidQr,
              height: 250,
              width: 250,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 30,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                "Scan the business QR code once more to view the menu.!",
                style: GoogleFonts.nunito(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
