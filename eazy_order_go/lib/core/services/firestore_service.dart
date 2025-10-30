import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String collectionBusiness = 'businesses';
  static const String collectionCatalog = 'catalog';
  static const String collectionOrder = 'orders';
  static const String collectionReports = 'reports';

  /// Add data to a collection
  Future<void> addDocument(String collectionPath, Map<String, dynamic> data) async {
    await _db.collection(collectionPath).add(data);
  }

  /// Update data in document
  Future<void> updateInnerDocument(String collectionPath, String docId, String field, Map<String, dynamic> data) async {
    final docRef = _db.collection(collectionPath).doc(docId);
    await docRef.update({
      field: FieldValue.arrayUnion([data]),
    });
  }

  Future<void> updateListDocument(String collectionPath, String docId, String field, List<Map<String, dynamic>> data) async {
    final docRef = _db.collection(collectionPath).doc(docId);
    await docRef.update({
      field: data,
    });
  }

  Future<void> updateDocument(String collectionPath, String docId, String field, String data) async {
    final docRef = _db.collection(collectionPath).doc(docId);
    await docRef.update({
      field: data,
    });
  }

  Future<void> updateMultiFieldDocument(String collectionPath, String docId, List<Map<String, String>> data) async {
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

  /// Delete document
  Future<void> deleteDocument(String collectionPath, String docId) async {
    await _db.collection(collectionPath).doc(docId).delete();
  }

  /// Get document by ID
  Future<DocumentSnapshot<Map<String, dynamic>>> getDocument(String collectionPath, String docId) async {
    return await _db.collection(collectionPath).doc(docId).get();
  }

  Future<Map<String, dynamic>> querySnapshotSingleData(String collection, String field, String value) async {
    final querySnapshot = await _db
        .collection(collection)
        .where(field, isEqualTo: value)
        .limit(1)
        .get();

    final Map<String, dynamic> result = querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first.data() : {};
    return result;
  }

  Future<List<Map<String, dynamic>>> querySnapshotListData(String collection, String field, String value) async {
    final querySnapshot = await _db
        .collection(collection)
        .where(field, isEqualTo: value)
        .get();

    List<Map<String, dynamic>> dataList = querySnapshot.docs
        .map((doc) => doc.data())
        .toList();

    return dataList;
  }

  Future<List<Map<String, dynamic>>> snapshotListDataWithLimit(String collection, String field, String value) async {
    final querySnapshot = await _db
        .collection(collection)
        .where(field, isEqualTo: value)
        .limit(20)
        .orderBy('created_at', descending: true)
        .get();

    List<Map<String, dynamic>> dataList = querySnapshot.docs
        .map((doc) => doc.data())
        .toList();

    return dataList;
  }

  Stream<List<Map<String, dynamic>>> todayOrderSnapshot(String businessId, String orderStatus) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day).toIso8601String();
    final end = DateTime(now.year, now.month, now.day + 1).toIso8601String();

    try {
      Query query = _db.collection(FirestoreService.collectionOrder)
          .where('business_id', isEqualTo: businessId)
          .where('created_at', isGreaterThanOrEqualTo: start)
          .where('created_at', isLessThan: end)
          .orderBy('created_at', descending: true);

      if (orderStatus.isNotEmpty && orderStatus != 'All') {
        query = query.where('order_status', isEqualTo: orderStatus.toLowerCase());
      }

      return query.snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
          });
    } catch (e) {
      debugPrint("Error while fetching today's records $e");
      return Stream.value([]);
    }
  }

  Future<void> setDocument(String collection, String id, Map<String, dynamic> data) async {

    final docRef = _db.collection(collection).doc(id);
    try {
      await docRef.set(data);
      debugPrint('Saved successfully!');
    } catch (e) {
      debugPrint('Error saving business: $e');
    }
  }

  Future setOrderTransaction(String collection, String id, Map<String, dynamic> orderData) async {
    final counterRef = _db.collection('orders_meta').doc('counter');
    final ordersRef = _db.collection(collection);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final counterSnapshot = await transaction.get(counterRef);

      int lastOrderNumber = counterSnapshot.exists
          ? counterSnapshot.get('last_order_number') as int
          : 0;

      int newOrderNumber = lastOrderNumber + 1;
      String formattedOrderNumber = newOrderNumber.toString().padLeft(3, '0');

      // Update the counter
      transaction.update(counterRef, {'last_order_number': newOrderNumber});

      // Add the order with the formatted order number
      orderData['order_invoice_number'] = formattedOrderNumber;

      final newOrderDoc = ordersRef.doc(id);
      transaction.set(newOrderDoc, orderData);
    });
  }

  Future<Map<String, dynamic>> getTodaySReportSnapshot(String collection, String docId) async {
    final querySnapshot = await _db
        .collection(collection)
        .doc(docId)
        .get();

    Map<String, dynamic> data = querySnapshot.data() ?? {};
    final safeData = convertTimestamps(data);

    return safeData;
  }

  Map<String, dynamic> convertTimestamps(Map<String, dynamic> data) {
    return data.map((key, value) {
      if (value is Timestamp) {
        return MapEntry(key, value.toDate().toIso8601String());
      } else if (value is Map) {
        return MapEntry(key, convertTimestamps(Map<String, dynamic>.from(value)));
      } else {
        return MapEntry(key, value);
      }
    });
  }
}

// Firestore Service provider
final firestoreServiceProvider = Provider((ref) => FirestoreService());
