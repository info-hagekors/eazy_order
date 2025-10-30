
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {
  late Razorpay _razorpay;

  final void Function(PaymentSuccessResponse response)? onSuccess;
  final void Function(String code, String? message)? onError;
  final void Function(String walletName)? onExternalWallet;

  PaymentService({
    this.onSuccess,
    this.onError,
    this.onExternalWallet,
  }) {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void dispose() {
    _razorpay.clear();
  }

  void openCheckout({
    required String orderId,
    required int amount,
    required String customerName,
    required String mobile,
    required String businessName,
    required String businessLogo,
    required String orderNumber,
  }) {
    final options = {
      'key': AppConsts.razorpayApiKey,
      'order_id': orderId,
      'amount': amount * 100, // Amount in paise
      'currency': 'INR',
      'name': businessName,
      'description': 'Payment for order #$orderNumber',
      'image': businessLogo,
      'prefill': {
        'contact': mobile,
        'name': customerName,
      },
      'theme': {
        'color': '#6F4F37',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (onSuccess != null) {
      onSuccess!(response);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (onError != null) {
      onError!(response.code.toString(), response.message);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (onExternalWallet != null) {
      onExternalWallet!(response.walletName ?? '');
    }
  }
}
