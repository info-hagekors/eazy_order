import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class FirebaseFunctionsService {
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(region: 'us-central1');

  /// Sends a notification to the business app when a customer places an order
  Future<Map<String, dynamic>> notifyBusinessOnOrder({
    required String orderId,
    required String orderNumber,
    required String customerName,
    required String token,
    required String amount,
  }) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable('notifyBusinessOnOrder');
      final response = await callable.call({
        'orderId': orderId,
        'orderNumber': orderNumber,
        'customerName': customerName,
        'token': token,
        'amount': amount
      });

      return {
        'success': true,
        'data': response.data,
      };
    } on FirebaseFunctionsException catch (e) {
      return {
        'success': false,
        'message': e.message ?? 'Function error',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Unexpected error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> createOrder({
    required int amount,
    String currency = 'INR',
    required String receipt,
  }) async {
    try {
      final uri = Uri.parse(
        'https://us-central1-eazy-order-fcb5b.cloudfunctions.net/createRazorpayOrderApi',
      );

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'amount': amount,
          'receipt': receipt,
          'currency': currency,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception("Error: ${error['message'] ?? response.reasonPhrase}");
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Unexpected error: $e',
      };
    }
  }

  Future<void> sendWhatsAppMessage(OrderModel model, String businessName) async {
    final url = Uri.parse('https://us-central1-eazy-order-fcb5b.cloudfunctions.net/sendWhatsappOrderConfirmationMessage');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'phoneNumber': '91${model.orderMobileNumber}',
        'customerName': model.orderUserName,
        'businessName': businessName,
        'orderNumber': model.orderInvoiceNumber.isNotEmpty ? model.orderInvoiceNumber : 'N/A',
        'orderDate': (model.createdAt ?? '').formatDate(),
        'orderTotal': model.orderTotal.toString(),
        'orderUrl': model.orderId,
      }),
    );

    if (response.statusCode == 200) {
      print('Message sent successfully: ${response.body}');
    } else {
      print('Error sending message: ${response.body}');
    }
  }
}
