@JS()
library razorpay_interop;

import 'dart:js_interop';

@JS('Razorpay')
extension type Razorpay._(JSObject _) {
  external Razorpay(RazorpayOptions options);
  external void open();
  external void on(String event, JSFunction callback);
}

extension type RazorpayOptions._(JSObject _) implements JSObject {
  external factory RazorpayOptions({
    String key,
    int amount,
    String currency,
    String name,
    String description,
    String order_id,
    String image,
    RazorpayPrefill prefill,
    RazorpayTheme theme,
    JSFunction handler,
    RazorpayModal modal,
  });

  external String get key;
  external int get amount;
  external String get currency;
  external String get name;
  external String get description;
  external String get order_id;
  external RazorpayPrefill get prefill;
  external RazorpayTheme get theme;
  external JSFunction get handler;
  external RazorpayModal get modal;
}

extension type RazorpayPrefill._(JSObject _) implements JSObject {
  external factory RazorpayPrefill({
    String name,
    String email,
    String contact,
  });

  external String get name;
  external String get email;
  external String get contact;
}

extension type RazorpayTheme._(JSObject _) implements JSObject {
  external factory RazorpayTheme({String color});
  external String get color;
}

extension type RazorpayResponse._(JSObject _) implements JSObject {
  external String get razorpay_payment_id;
  external String get razorpay_order_id;
  external String get razorpay_signature;
}

extension type RazorpayModal._(JSObject _) implements JSObject {
  external factory RazorpayModal({
    JSFunction ondismiss,
  });

  external JSFunction get ondismiss;
}

