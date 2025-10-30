import 'package:eazy_order_go/core/services/firestore_service.dart';
import 'package:core/core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class AuthRepository {

  final FirestoreService _firestoreService;

  AuthRepository(this._firestoreService);

  Future<BusinessModel> getBusinessByMobile(String mobile) async {

    final result = await _firestoreService.querySnapshotSingleData(
        FirestoreService.collectionBusiness, 'mobile', mobile
    );
    BusinessModel model = BusinessModel.fromJson(result);
    return model;
  }

}

// Auth Repository provider
final authRepositoryProvider = Provider((ref) => AuthRepository(ref.read(firestoreServiceProvider)));
