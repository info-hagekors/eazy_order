
import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class FirebaseFunctionsService {
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(region: 'us-central1');

  /// Sends OTP using the deployed Cloud Function
  Future<Map<String, dynamic>> sendOtp(String mobile) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable('sendOtp');
      final response = await callable.call({'mobile': mobile});
      return {'success': true, 'data': response.data};
    } on FirebaseFunctionsException catch (e) {
      return {'success': false, 'message': e.message ?? 'Function error'};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error: $e'};
    }
  }

  /// Verifies OTP using the deployed Cloud Function
  Future<Map<String, dynamic>> verifyOtp(String mobile, String otp) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable('verifyOtp');
      final response = await callable.call({'mobile': mobile, 'otp': otp});
      return {'success': true, 'data': response.data};
    } on FirebaseFunctionsException catch (e) {
      return {'success': false, 'message': e.message ?? 'Function error'};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error: $e'};
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
}

// Firestore Service provider
final firebaseFunctionsServiceProvider = Provider((ref) => FirebaseFunctionsService());
