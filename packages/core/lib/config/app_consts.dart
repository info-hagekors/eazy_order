
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppConsts {

  AppConsts(this.context);

  BuildContext context;
  static double _bottomPadding = 0;
  static final String _defaultPin = '15253';
  static final String _webAppUrl = 'https://eazy-order-fcb5b.web.app/id=';
  static final int _productImageSelectionLimit = 5;

  static final bool isWeb = kIsWeb;
  static final String _currencySymbol = '₹';
  static final double _webAppWidth = 440;

  static final List<String> _orderPreference = ['Dine In', 'Take Away Parcel'];

  static final List<String> _paymentOptions = ['Online', 'Cash', 'Pay Later at Counter'];

  static final String _razorpayApiKey = 'rzp_test_AIOvYGTldO3R2v';

  static final String _privacyPolicy = 'https://eazy-order-fcb5b.web.app/privacy-policy.html';
  static final String _termsCondition = 'https://eazy-order-fcb5b.web.app/terms-and-conditions.html';
  static final String _refundPolicy = 'https://eazy-order-fcb5b.web.app/refund-policy.html';

  static final List<String> _orderStatus = ['Placed', 'Confirm', 'Complete', 'Cancel'];

  static final List<String> _paymentStatus = ['Pending', 'Paid', 'Failed'];

  static final int _otpLength = 6;

  void init() {
    _bottomPadding = MediaQuery.of(context).viewPadding.bottom;
  }

  static double get bottomPadding => _bottomPadding;

  static String get defaultPin => _defaultPin;

  static String get webAppUrl => _webAppUrl;

  static int get productImageSelectionLimit => _productImageSelectionLimit;

  static String get currencySymbol => _currencySymbol;

  static List<String> get orderPreference => _orderPreference;

  static List<String> get paymentOptions => _paymentOptions;

  static String get razorpayApiKey => _razorpayApiKey;

  static String get privacyPolicy => _privacyPolicy;
  static String get termsCondition => _termsCondition;
  static String get refundPolicy => _refundPolicy;

  static List<String> get orderStatus => _orderStatus;
  static List<String> get paymentStatus => _paymentStatus;

  static DateTime get todayStart {
    final now = DateTime.now().toUtc();
    return DateTime(now.year, now.month, now.day); // 00:00
  }

  static DateTime get todayEnd {
    return todayStart.add(Duration(days: 1)); // tomorrow 00:00
  }

  static double get webAppWidth => _webAppWidth;

  static String _businessId = '';

  static String get businessId => _businessId;

  static set setBusinessId(String value) => _businessId = value;

  static int get otpLength => _otpLength;

}