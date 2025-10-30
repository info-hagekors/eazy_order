
import 'dart:io';
import 'dart:ui';

import 'package:eazy_order_go/core/services/secure_storage_service.dart';
import 'package:eazy_order_go/feature/auth/repository/auth_repository.dart';
import 'package:core/core.dart';
import 'package:eazy_order_go/feature/home/entities/qr_code_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

part 'qr_code_controller.g.dart'; // Required for code generation

@Riverpod(keepAlive: true)
class QrCodeController extends _$QrCodeController {

  @override
  QrCodeEntity build() {
    return QrCodeEntity();
  }

  void getBusinessData() async {
    await Future.delayed(Duration(milliseconds: 50));
    final mobile = await ref.read(secureStorageServiceProvider).getMobile();
    BusinessModel business = await ref.read(authRepositoryProvider).getBusinessByMobile(mobile);
    state = state.copyWith(businessModel: business);
  }

  Future<void> shareQrCode(qrKey) async {
    try {
      // Render QR code image from RepaintBoundary
      RenderRepaintBoundary boundary = qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 4.0); // High resolution
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save image to temp file
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/qr_code.png';
      final file = File(imagePath);
      await file.writeAsBytes(pngBytes);

      // Share
      final params = ShareParams(
        text: 'Business Name',
        files: [XFile(file.path),],
      );
      await SharePlus.instance.share(params);
    } catch (e) {
      debugPrint('Error sharing QR code: $e');
    }
  }
}
