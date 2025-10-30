import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/core.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class BusinessService {

  static const String collectionBusiness = 'businesses';
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static final BusinessService _instance = BusinessService._internal();
  factory BusinessService() => _instance;
  BusinessService._internal();

  Future<void> addBusiness(String id, Map<String, dynamic> data) async {
    final docRef = _db.collection(collectionBusiness).doc(id);
    try {
      await docRef.set(data);
      debugPrint('Saved successfully!');
    } catch (e) {
      debugPrint('Error saving business: $e');
    }
  }

  Future<Either<String, BusinessModel>> getBusinessById(String businessId) async {
    try {
      QuerySnapshot snapshot = await _db
          .collection(collectionBusiness)
          .where('business_id', isEqualTo: businessId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final result =  doc.data() as Map<String, dynamic>;
        final business = BusinessModel.fromJson(result);
        return Right(business);
      } else {
        return Left('Business not found...!');
      }
    } catch (e) {
      debugPrint('Something went wrong...: $e');
      return Left('Something went wrong...!');
    }
  }

  Future<void> updateBusinessFcmToken(String businessId, String token) async {
    await _updateMultiFieldDocument(collectionBusiness, businessId,
        [
          {'field': 'fcm_token', 'value': token},
          {'field': 'updated_at', 'value': DateTime.now().toIso8601String()},
        ]
    );
  }

  Future<void> _updateMultiFieldDocument(String collectionPath, String docId, List<Map<String, String>> data) async {
    final docRef = _db.collection(collectionPath).doc(docId);
    final updateData = data.fold<Map<String, dynamic>>({}, (map, item) {
      final field = item['field'];
      if (field is String && field.isNotEmpty) {
        map[field] = item['value'];
      }
      return map;
    });
    await docRef.update(updateData);
  }
}

// Business Repository provider
final businessServiceProvider = Provider((ref) => BusinessService());
