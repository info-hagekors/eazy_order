import 'package:eazy_order_go/core/services/firestore_service.dart';
import 'package:core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class BusinessSetupRepository {

  final FirestoreService _firestoreService;

  BusinessSetupRepository(this._firestoreService);

  Future<void> addNewBusiness(BusinessModel model) async {
    final data = {
      'business_id': model.businessId,
      'name': model.name,
      'mobile': model.mobile,
      'address': model.address,
      'logo': model.logo,
      'is_setup_completed': model.isSetupCompleted,
      'fcm_token': model.token,
      'order_preference': model.orderPreference,
      'payment_options': model.paymentOptions,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
    await _firestoreService.setDocument(FirestoreService.collectionBusiness, model.mobile, data);
  }

  Future<void> updateBusinessFcmToken(String businessId, String token) async {
    await _firestoreService.updateMultiFieldDocument(
        FirestoreService.collectionBusiness,
        businessId,
        [
          {'field': 'fcm_token', 'value': token},
          {'field': 'updated_at', 'value': DateTime.now().toIso8601String()},
        ]
    );
  }
}

// Auth Repository provider
final businessSetupRepositoryProvider = Provider((ref) => BusinessSetupRepository(ref.read(firestoreServiceProvider)));
