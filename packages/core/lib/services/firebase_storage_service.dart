
import 'dart:io' as io;
import 'package:mime/mime.dart';
import 'package:web/web.dart' as web;

import 'package:core/core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final String _businessImagePath = 'business_logo';
  final String _productImagePath = 'product_images';

  final ImagePicker _picker = ImagePicker();

  // Pick image using image_picker
  Future<XFile?> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  // Pick multiple image using image_picker
  Future<List<XFile>> pickMultipleImagesFromGallery() async {
    final List<XFile> selectedImages = await _picker.pickMultiImage(limit: AppConsts.productImageSelectionLimit);
    if (selectedImages.isEmpty) return [];
    final List<XFile> images = selectedImages.map((e) => XFile(e.path)).toList();
    return images;
  }

  // Upload image and return download URL
  Future<String?> uploadBusinessImage(XFile imageFile, String mobile) async {
    try {
      final storageRef = _storage.ref().child('$_businessImagePath/$mobile');
      if (kIsWeb) {
        final bytes = await imageFile.readAsBytes();
        //final metadata = SettableMetadata(contentType: 'image/jpeg',);
        await storageRef.putData(bytes);
        return await storageRef.getDownloadURL();
      } else {
        await storageRef.putFile(io.File(imageFile.path));
        return await storageRef.getDownloadURL();
      }
    } catch (e) {
      debugPrint('Upload error: $e');
      return null;
    }
  }

  Future<List<String>> uploadMultipleProductImages(List<XFile> imageFiles, String businessId,) async {
    List<String> downloadUrls = [];

    for (int i = 0; i < imageFiles.length; i++) {
      final file = imageFiles[i];
      final uniqueId = const Uuid().v4();
      try {
        if (kIsWeb) {
          final storageRef = _storage.ref().child('$_productImagePath/$businessId/$uniqueId');
          final bytes = await file.readAsBytes();
          final mime = lookupMimeType('Image', headerBytes: bytes);
          final metadata = SettableMetadata(contentType: mime ?? 'image/jpeg',);
          await storageRef.putData(bytes, metadata);
          final url = await storageRef.getDownloadURL();
          downloadUrls.add(url);
        } else {
          final storageRef = _storage.ref().child('$_productImagePath/$businessId/$uniqueId');
          await storageRef.putFile(io.File(file.path));
          final url = await storageRef.getDownloadURL();
          downloadUrls.add(url);
        }
      } catch (e) {
        debugPrint('Upload error for image $i: $e');
        // Optionally continue or break here depending on failure handling strategy
      }
    }
    return downloadUrls;
  }

  Future<List<String>> uploadMultipleProductImagesWeb(List<Uint8List> imageFiles, String businessId,) async {
    List<String> downloadUrls = [];

    for (int i = 0; i < imageFiles.length; i++) {
      final file = imageFiles[i];
      final uniqueId = const Uuid().v4();
      try {
        final storageRef = _storage.ref().child('$_productImagePath/$businessId/$uniqueId');
        final mime = lookupMimeType('Image', headerBytes: file);
        final metadata = SettableMetadata(contentType: mime ?? 'image/jpeg',);
        await storageRef.putData(file, metadata);
        final url = await storageRef.getDownloadURL();
        downloadUrls.add(url);
      } catch (e) {
        debugPrint('Upload error for image $i: $e');
        // Optionally continue or break here depending on failure handling strategy
      }
    }
    return downloadUrls;
  }

}

// Firebase Storage Service provider
final firebaseStorageServiceProvider = Provider((ref) => FirebaseStorageService());
