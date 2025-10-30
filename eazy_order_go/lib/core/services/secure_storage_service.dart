import 'package:encrypt/encrypt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class _SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static final _key = Key.fromUtf8('f3a2c5d984e71b0c47fa92eb8a7c4d63');
  static final _iv = IV.fromLength(16);
  static final _encrypter = Encrypter(AES(_key));

  // Write data
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Read data
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  // Delete a specific key
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  // Delete all stored data
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<void> storeMobile(String mobile) async {
    final encrypted = _encrypter.encrypt(mobile, iv: _iv);
    await _storage.write(key: 'mobile_iv', value: _iv.base64);
    await _storage.write(key: 'mobile', value: encrypted.base64);
  }

  Future<String> getMobile() async {
    final encryptedMobile = await _storage.read(key: 'mobile');
    final encryptedMobileIv = await _storage.read(key: 'mobile_iv');
    if (encryptedMobile == null || encryptedMobileIv == null) return '';

    final iv = IV.fromBase64(encryptedMobileIv);
    final decrypted = _encrypter.decrypt64(encryptedMobile, iv: iv);
    return decrypted;
  }
}

// Firestore Service provider
final secureStorageServiceProvider = Provider((ref) => _SecureStorageService());
