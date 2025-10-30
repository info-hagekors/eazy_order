/*
import 'dart:js_interop';
import 'dart:js_util' as js_util;

import 'package:eazy_order_admin/web/razorpay_interop.dart';
import 'package:flutter/foundation.dart';

class RazorpayWebService {
  void openCheckout({
    required String apiKey,
    required String orderId,
    required int amount, // in paise
    required String customerName,
    required String description,
    required String currency,
    required void Function(Map) onSuccess,
    required void Function(String error) onFailure,
    String mobile = '',
    String businessName = 'eazyOrder',
    String businessLogo = '',
  }) {
    if (!kIsWeb) return;

    final options = RazorpayOptions(
      key: apiKey,
      amount: amount,
      currency: currency,
      name: businessName,
      description: description,
      order_id: orderId,
      image: businessLogo,
      prefill: RazorpayPrefill(
        name: customerName,
        contact: mobile,
      ),
      handler: (JSAny response) {
        try {
          final paymentId = js_util.getProperty<String>(response, 'razorpay_payment_id');
          final returnedOrderId = js_util.getProperty<String>(response, 'razorpay_order_id');
          final signature = js_util.getProperty<String>(response, 'razorpay_signature');

          onSuccess({
            'razorpay_payment_id': paymentId,
            'razorpay_order_id': returnedOrderId,
            'razorpay_signature': signature,
          });
        } catch (e) {
          debugPrint('Razorpay Error > ${e.toString()}');
        }
      }.toJS,
      modal: RazorpayModal(
        ondismiss: () {
          onFailure('Checkout closed by user'); // 🔧 Finally works
        }.toJS,
      ),
    );

    final razorpay = Razorpay(options);
    razorpay.open();

    razorpay.on('payment.failed', (JSAny error) {
      final errorObj = error as JSObject;
      final errorMsg = errorObj.toString(); // Customize if needed
      onFailure(errorMsg);
    }.toJS);

    razorpay.on('payment.error', (JSAny error) {
      final errorObj = error as JSObject;
      final errorMsg = errorObj.toString(); // Customize if needed
      onFailure(errorMsg);
    }.toJS);

    razorpay.on('dismiss', (JSAny error) {
      final errorObj = error as JSObject;
      final errorMsg = errorObj.toString(); // Customize if needed
      onFailure(errorMsg);
    }.toJS);
  }
}
*/
