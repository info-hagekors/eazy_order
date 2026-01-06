
import 'package:core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class BusinessRepository {

  final BusinessService _businessService;
  final AuthService _authService;

  BusinessRepository(this._businessService, this._authService);

  Future<void> addNewBusiness(BusinessModel model) async {
    final data = {
      'business_id': model.businessId,
      'admin_id': model.adminId,
      'business_name': model.name,
      'mobile': model.mobile,
      'address': model.address,
      'registration_no': model.registrationNo,
      'logo': model.logo,
      'is_setup_completed': model.isSetupCompleted,
      'fcm_token': model.token,
      'order_preference': model.orderPreference,
      'payment_options': model.paymentOptions,
      'createdAt': model.createdAt,
      'updatedAt': model.updatedAt,
    };
    await _businessService.addBusiness(model.businessId, data);
    await _authService.updateBusinessId(model.businessId, model.adminId);
  }

  Future<void> updateBusinessFcmToken(String businessId, String token) async {
    await _businessService.updateBusinessFcmToken(businessId, token);
  }

  Future<UserModel> getCurrentUser() async {
    final result = await _authService.getUser(_authService.currentUser?.uid ?? '');
    print(result.toMap().toString());
    return result;
  }
}

// Repository provider
final businessRepositoryProvider = Provider((ref) => BusinessRepository(
    ref.read(businessServiceProvider), ref.read(authServiceProvider))
);
