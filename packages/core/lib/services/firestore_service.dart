
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String collectionBusiness = 'businesses';
  static const String collectionCatalog = 'catalog';
  static const String collectionCategory = 'category';
  static const String collectionProduct = 'product';
  static const String collectionOrder = 'orders';

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

  Future<void> updateDocument(String collectionPath, String docId, String field, dynamic data) async {
    final docRef = _db.collection(collectionPath).doc(docId);
    await docRef.update({
      field: data,
    });
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
    try {
      final querySnapshot = await _db
          .collection(collection)
          .where(field, isEqualTo: value)
          .limit(1)
          .get();

      final Map<String, dynamic> result = querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first.data() : {};
      return result;
    } catch(e) {
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> querySnapshotListData(String collection, String field, String value) async {
    try {
      final querySnapshot = await _db
          .collection(collection)
          .where(field, isEqualTo: value)
          .get();

      List<Map<String, dynamic>> dataList = querySnapshot.docs
          .map((doc) => doc.data())
          .toList();

      return dataList;
    } catch(e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<void> setDocument(String collection, String id, Map<String, dynamic> data) async {
    final docRef = _db.collection(collection).doc(id);
    try {
      await docRef.set(data, SetOptions(merge: true));
      debugPrint('Saved successfully!');
    } catch (e) {
      debugPrint('Error saving business: $e');
    }
  }

  Future<String> setOrderTransaction(String collection, String id, Map<String, dynamic> orderData) async {
    final counterRef = _db.collection('orders_meta').doc('counter');
    final ordersRef = _db.collection(collection);

    String invoiceNo = '';

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
      invoiceNo = formattedOrderNumber;

      final newOrderDoc = ordersRef.doc(id);
      transaction.set(newOrderDoc, orderData);
    });
    return invoiceNo;
  }
}

// Firestore Service provider
final firestoreServiceProvider = Provider((ref) => FirestoreService());
