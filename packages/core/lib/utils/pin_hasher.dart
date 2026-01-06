import 'dart:convert';
import 'package:crypto/crypto.dart';

class PinHasher {
  static String hashPin(String pin, {required String salt}) {
    final bytes = utf8.encode('$pin$salt');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
