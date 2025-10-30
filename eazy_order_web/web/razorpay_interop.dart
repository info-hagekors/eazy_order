@JS()
library razorpay_interop;

import 'package:js/js.dart';

@JS('Razorpay')
class Razorpay {
  external Razorpay(RazorpayOptions options);
  external void open();
  external void on(String event, Function callback);
}

@JS()
@anonymous
class RazorpayOptions {
  external factory RazorpayOptions({
    String key,
    int amount,
    String currency,
    String name,
    String description,
    String order_id,
    RazorpayPrefill prefill,
    RazorpayTheme theme,
    Function(RazorpayResponse) handler,
  });

  external String get key;
  external int get amount;
  external String get currency;
  external String get name;
  external String get description;
  external String get order_id;
  external RazorpayPrefill get prefill;
  external RazorpayTheme get theme;
  external Function(RazorpayResponse) get handler;
}

@JS()
@anonymous
class RazorpayPrefill {
  external factory RazorpayPrefill({
    String name,
    String email,
    String contact,
  });

  external String get name;
  external String get email;
  external String get contact;
}

@JS()
@anonymous
class RazorpayTheme {
  external factory RazorpayTheme({String color});

  external String get color;
}

@JS()
@anonymous
class RazorpayResponse {
  external String get razorpay_payment_id;
  external String get razorpay_order_id;
  external String get razorpay_signature;
}
